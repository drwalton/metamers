function m = mkImMasks(opts)

%
%-----------------------------------------
% m = mkImMasks(opts)
%
% generates a family of window functions
% for use with metamer analysis and synthesis
% model (see metamerAnalysis.m and metamerSynthesis.m)
%
% opts: parameter vector (see initParams.m)
%
% m: structure containing window functions
%
% freeman, 12/25/2008
%-----------------------------------------

% grab some parameter values
Nsc = opts.Nsc;
Nor = opts.Nor;
maxNa = opts.maxNa;

% build dummy steerable pyramid  
if isempty(opts.subIm)
    [pyr0,pind0] = buildSCFpyr(zeros(opts.szy,opts.szx),Nsc,Nor-1);
else
    [pyr0,pind0] = buildSCFpyr(zeros(1+opts.subIm(2)-opts.subIm(1), 1+opts.subIm(4)-opts.subIm(3)), Nsc, Nor-1);
end

% get scales
scales = pind0(2:Nor:end,:);

% make windows at base scale
switch opts.windows.windowType
case 'radial'
    thisSz = scales(1,:);
    m.scale{1}.size = [thisSz(2), thisSz(1)];
    m.scale{1}.maskMat = mkMasksRadial(thisSz,opts.windows,opts.verbose);
case 'square'
    thisSz = scales(1,:);
    m.scale{1}.size = [thisSz(2), thisSz(1)];
    m.scale{1}.maskMat = mkMasksSquare(thisSz,opts.windows,opts.verbose);
case 'radialEquirectangular'
    thisSz = [opts.szy, opts.szx];
    
    if isempty(opts.subIm)
        m.scale{1}.maskMat = mkMasksRadialEquirectangular(thisSz,opts.windows,opts.verbose);
        m.scale{1}.size = [thisSz(2), thisSz(1)];
    else
        m.scale{1}.maskMat = mkMasksRadialEquirectangular(thisSz,opts.windows,opts.verbose, opts.subIm);
        m.scale{1}.size = [1+opts.subIm(2)-opts.subIm(1), 1+opts.subIm(4)-opts.subIm(3)];
    end
end
m.scale{1}.nMasks = size(m.scale{1}.maskMat,1);

% preallocate matrices
for insc=2:Nsc+1
    m.scale{insc}.maskMat = zeros(m.scale{1}.nMasks,scales(insc,1),scales(insc,2));
    m.scale{insc}.maskNorm = zeros(scales(insc,1)*scales(insc,2),m.scale{1}.nMasks);
end

% make additional windows using gaussian pyramid
for imask=1:m.scale{1}.nMasks
    tmp = squeeze(m.scale{1}.maskMat(imask,:,:));
    [maskpyr maskpind] = buildGpyr(tmp);
    for insc=2:Nsc+1
        m.scale{insc}.maskMat(imask,:,:) = pyrBand(maskpyr,maskpind,insc)/2^(insc-1);
    end
end

% precompute reformatted windows at all scales
for insc=1:Nsc+1
    m.scale{insc}.nMasks = m.scale{1}.nMasks;
    for imask=1:m.scale{insc}.nMasks
        if nnz(squeeze(m.scale{insc}.maskMat(imask,:,:))) == 0
            print('a');
        end
        [indices minBoundBox numNonZero] = findZeros(squeeze(m.scale{insc}.maskMat(imask,:,:)));
        m.scale{insc}.ind(imask,:) = indices;
        m.scale{insc}.sz(imask) = numNonZero;
        m.scale{insc}.Na(imask) = min(minBoundBox,maxNa);
        m.scale{insc}.maskNorm(:,imask) = vector(m.scale{insc}.maskMat(imask,:,:))/sum(vector(m.scale{insc}.maskMat(imask,:,:)));
    end
end

% store indices into scales
if Nsc == 4
m.bandToMaskScale = [1 1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4 5];
end
if Nsc == 5
    m.bandToMaskScale = [1 1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4 5 5 5 5 6];
end

