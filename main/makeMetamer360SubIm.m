%% New equirectangular demo
%
% This version uses windows that tile the image in
% polar angle and log eccentricity, with parameters 
% used to generate metamers in Freeman & Simoncelli
%
% This version only generates a metamer for a sub-image around the focal
% point, allowing it to handle higher-resolution inputs.

% load original image
oim = double(imread('passau.png'));
origin = (size(oim) + 1) ./ 2;

%find coords of subIm to extract
subImW = 512;
subImH = 512;
subIm = [origin(1)-(subImH/2), origin(1)+(subImH/2)-1, origin(2)-(subImW/2), origin(2)+(subImW/2)-1];
subIm = floor(subIm);

%Extract sub-image
subOim = oim(subIm(1):subIm(2), subIm(3):subIm(4));
assert(isequal(size(subOim), [subImH, subImW]));

% set options
opts = metamerOpts(oim,'windowType=radialEquirectangular','scale=0.5','aspect=2', strcat('subIm=', mat2str(subIm)));

% make windows
m = mkImMasks(opts);

% plot windows
plotWindows(m,opts);

% do metamer analysis on original (measure statistics)
params = metamerAnalysis(subOim,m,opts);

% do metamer synthesis (generate new image matched for statistics)
res = metamerSynthesis(params,size(subOim),m,opts);

% Plug the generated metamer back into the original image
metamer = oim;
metamer(subIm(1):subIm(2), subIm(3):subIm(4)) = res;

imwrite(metamer/255, 'outputMetamer.png');
