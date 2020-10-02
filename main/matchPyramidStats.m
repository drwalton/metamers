oim = double(imread('example-im-512x512.png'));

origin = (size(oim) + 1) ./ 2;
opts = metamerOpts(oim,'windowType=radial','scale=0.5', ...
    'aspect=2', 'nIters=25', ...
    strcat('origin=', mat2str(origin)));
Nsc = opts.Nsc;
Nor = opts.Nor;
% Generate pyramid for original image
[pyr0, pind0] = buildSCFpyr(oim, Nsc, Nor-1);

%Generate initial output noise image.
im_mean = mean2(oim);
im_var = var2(oim);
outputIm = randn(size(oim))*sqrt(im_var) + im_mean;

[outputPyr, outputPind] = buildSCFpyr(outputIm, Nsc, Nor-1);

lobandIndices = pyrBandIndices(pind0, size(pind0,1));

%Copy low-frequency band to output pyramid.
outputPyr(lobandIndices) = pyr0(lobandIndices);

%Make masks.
m = mkImMasks(opts);
