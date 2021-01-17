%% New equirectangular demo
%
% This version uses windows that tile the image in
% polar angle and log eccentricity, with parameters 
% used to generate metamers in Freeman & Simoncelli
%
% This version only generates a metamer for a sub-image around the focal
% point, allowing it to handle higher-resolution inputs.

function makeMetamer360SubIm(oim, angle, outputFilename, initIm)

%Adding this for now as otherwise the 
%origin = (size(oim) + 1) ./ 2;

origin = [size(oim, 1)/2, size(oim, 2)/2];
origin(2) = origin(2) + (angle / 360) * size(oim, 2);

fprintf("Angle %f", angle)
fprintf("Origin %f %f", origin(1), origin(2))

%find coords of subIm to extract
subImW = 512;
subImH = 512;
%This version extracts a sub-image centred on the origin point.
top = origin(1)-subImH/2;
bottom = origin(1)+subImH/2 - 1;
left = origin(2)-subImH/2;
right = origin(2)+subImH/2 - 1;
%subIm = oim(top:bottom, left:right);
%imshow(subIm);
subIm = [top, bottom, left, right];

%This alternative version centres it horizontally only, just capturing the
%full vertical extent of the image.
%subIm = [1, 1024,  origin(2)-(subImW/2)+1, origin(2)+(subImW/2)];

subIm = floor(subIm);

%Extract sub-image
subOim = oim(subIm(1):subIm(2), subIm(3):subIm(4));
assert(isequal(size(subOim), [subImH, subImW]));

% set options
opts = metamerOpts(oim,'windowType=radialEquirectangular','scale=0.5', ...
    'aspect=2', 'nIters=25', strcat('subIm=', mat2str(subIm)), ...
    strcat('origin=', mat2str(origin)));

% make windows
m = mkImMasks(opts);

% plot windows
%plotWindows(m,opts);

% do metamer analysis on original (measure statistics)
params = metamerAnalysis(subOim,m,opts);

% do metamer synthesis (generate new image matched for statistics)
if exist('initIm') == 0
    res = metamerSynthesis(params,size(subOim),m,opts);
else
    subInitIm = initIm(subIm(1):subIm(2), subIm(3):subIm(4));
    res = metamerSynthesis(params,subInitIm,m,opts);
end

% Plug the generated metamer back into the original image
metamer = oim;
metamer(subIm(1):subIm(2), subIm(3):subIm(4)) = res;

imwrite(metamer/255, outputFilename);
