oim = rgb2gray(double(imread('diff.bmp')));

%Generate initial output noise image.
im_mean = mean2(oim);
im_var = var2(oim);
outputIm = randn(size(oim))*sqrt(im_var) + im_mean;

origin = (size(oim) + 1) ./ 2;

%Make windowing functions
opts = metamerOpts(oim,'windowType=radial','scale=0.5', ...
    'aspect=2', 'nIters=25', ...
    strcat('origin=', mat2str(origin)));
m = mkImMasks(opts);

plotWindows(m, opts);
epPixVar = 1;

%Find statistics for input.
statg0 = zeros(6,m.scale{1}.nMasks);
for imask = 1:m.scale{1}.nMasks
  thisMask = squeeze(m.scale{1}.maskMat(imask,:,:));
  thisMaskNAN = thisMask;
  thisMaskNAN(thisMaskNAN==0) = NaN;
  thisMaskNAN(thisMaskNAN>0) = 1;
  [mn0, mx0] = range2(oim.*thisMaskNAN);
  mean0 = wmean2(oim,thisMask);
  var0 = wvar2(oim,thisMask);
  skew0 = wskew2(oim,thisMask);
  kurt0 = wkurt2(oim,thisMask);
  statg0(:,imask) = [mean0 var0 skew0 kurt0 mn0 mx0]; 
end

W={};
% make normalized mask matrices
for iscale=1
  W.scale{iscale} = zeros(size(m.scale{iscale}.maskMat,2)*size(m.scale{iscale}.maskMat,3),m.scale{iscale}.nMasks);
  for iw=1:m.scale{iscale}.nMasks
    w = squeeze(m.scale{iscale}.maskMat(iw,:,:));
    W.scaleUnnorm{iscale}(:,iw) = vector(w);
    W.scale{iscale}(:,iw) = vector(w/sum(w(:)));
    W.scaleSq{iscale}(:,:,iw) = w/sum(w(:));
    W.scaleSqrt{iscale}(:,:,iw) = sqrt(w/sum(w(:)));
    W.ind{iscale}(:,iw) = m.scale{iscale}.ind(iw,:);
    W.Na{iscale}(iw) = m.scale{iscale}.Na(iw);
    W.sum{iscale} = sum(W.scaleUnnorm{iscale});
    W.sz{iscale}(iw) = m.scale{iscale}.sz(iw);
  end
  W.full{iscale} = reshape(sum(reshape(m.scale{iscale}.maskMat,size(m.scale{iscale}.maskMat,1),size(m.scale{iscale}.maskMat,2)*size(m.scale{iscale}.maskMat,3)),1),size(m.scale{iscale}.maskMat,2),size(m.scale{iscale}.maskMat,3));
end
outputIm = vector(outputIm);
targetMeans = statg0(1,:);
targetVars = statg0(2,:);
preCalcInv = pinv(W.scale{1}'*W.scale{1});

goodinds = find((W.sum{1}/numel(outputIm))>0.01);
Wtmp = W.scale{1}(:,goodinds);
Wsumtmp = W.sum{1}(goodinds);

for niter=1:opts.nIters
    outputIm = wmodkurt2(outputIm, statg0(3), Wtmp, Wsumtmp, 1, 0.05, 1);
    outputIm = wmodskew2(outputIm, statg0(3), Wtmp, Wsumtmp, 1, 50.0, 1);
    outputIm = wmodvar2(outputIm,targetVars,W.scale{1},W.sum{1},1,epPixVar);
    outputIm = wmodmean2(outputIm, targetMeans, W.scale{1}, preCalcInv);
    imwrite(uint8(outputIm), "imageStatOutputIm.png");
end

outputIm = reshape(outputIm, size(oim));
imwrite(uint8(outputIm), "imageStatOutputIm.png");
