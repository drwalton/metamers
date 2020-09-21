function [mask, sz] = mkMasksRadialEquirectangular(imSize,windows,verbose, subIm)

%
%-----------------------------------------
% mask = mkMasksRadialEquirectangular(imSize,windows)
%
% generates a family of radial window functions
% that tile evenly in angle and log eccentricity
%
% This equirectangular version of the version is designed to operate on
% 360 images in equirectangular format.
%
% imSize: size of image (2-vector)
% windows: structure containing window parameters
% (see initParams.m)
% 
% subIm is an optional parameter used when you want to generate windowing
% functions for just a small sub-image within the equirectangular image.
% Typically this would be a region around the focal point. If not supplied,
% windows will be generated for the whole image. This should be a vector of
% 4 indices such that im(subIm(1):subIm(2), subIm(3):subIm(4)) extracts the
% region of the image you want.
%
% masks: matrix of window functions
% sz: vector of window sizes
%
% freeman, 12/25/2008
%-----------------------------------------

% check arguments
if nargin < 1
	error('Need to specify size')
end

% grab window parameter values
origin = windows.origin;
scale = windows.scale;
aspect = windows.aspect;
overlap = [windows.overlap, windows.overlap];
centerRad = round(windows.centerRadPerc*(sqrt(prod(imSize))/2));

% create angle and distance matrices
[rVals, thetaVals] = mkRAndAngleEquirectangular(imSize, 0, origin, 1); 

if exist('subIm') ~= 0
    rVals = rVals(subIm(1):subIm(2), subIm(3):subIm(4));
    thetaVals = thetaVals(subIm(1):subIm(2), subIm(3):subIm(4));
    imSize = size(rVals);
end

thetaVals = thetaVals + pi; % define from 0 to 2pi
thetaVals(thetaVals==0) = 0.001;
rVals(rVals == 0) = 0.001;

% distance computations
centerRad = log2(centerRad);
tmp = 2*log2((scale+sqrt(scale^2+4))/2);
rTWidth = overlap(2)*tmp;
rWidth = (1-overlap(2))*tmp;
maxCirc = (sqrt(2)/2)*max(rVals(:));
rCenters =centerRad+rWidth+rTWidth:rWidth+rTWidth:(max(log2(rVals(:))))+rWidth+rTWidth;
nRs = length(rCenters);

% compute number of thetas given desired aspect ratio (requires rounding)
nThetas = round((aspect*2*pi)/(2^(tmp/2)-2^(-tmp/2)));
tmpWidth = (2*pi)/nThetas;

% compute circumferential transition width as a function of desired overlap
thetaTWidth = overlap(1)*tmpWidth;
thetaWidth = (2*pi)/nThetas - thetaTWidth;

% define angle centers and width
thetaCenters = (0:nThetas-1)*(thetaWidth+thetaTWidth)-thetaWidth/2;

%ratio =
%(2.^(rCenters+rWidth/2)-2.^(rCenters-rWidth/2))./((2*pi*2.^rCenters)/nThetas)s
mask = zeros(nThetas*nRs, imSize(1), imSize(2));
imask = 1;
if verbose; T = textWaitbar('(mkMasksRadial) making windows'); end
for itheta=1:nThetas
	[xThetaWin yThetaWin] = mkWinFunc(thetaCenters(itheta),thetaWidth,thetaTWidth,[0 2*pi],1);
	thetaMask = interp1(xThetaWin,yThetaWin,thetaVals);

	for ir=1:nRs
		
		[xRWin yRWin] = mkWinFuncLog(rCenters(ir),rWidth,rTWidth,[0 max(log2(rVals(:)))],0);    
		warning('off')
		rMask = (2.^interp1(xRWin,yRWin,log2(rVals),'linear'));
		rMask(isnan(rMask)) = 0;
		warning('on')

		testMat = thetaMask.*rMask;
		testMat(isnan(testMat)) = 0;
		if nnz(testMat) > 0;%~isequal(testMat,zeros(size(thetaMask)))
			mask(imask,:,:) = testMat;
			sz(imask) = (2^(rCenters(ir)+rWidth+rTWidth) - 2^(rCenters(ir)-rWidth-rTWidth));
			imask = imask + 1;
		end
	end
	if verbose; T = textWaitbar(T,itheta/nThetas); end
end

mask = mask(1:imask-1, :, :);
mask(isnan(mask)) = 0;
