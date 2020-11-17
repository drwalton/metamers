% % This generates a metamer using windows that tile the image in
% % polar angle and log eccentricity, with parameters 
% % used to generate metamers in Freeman & Simoncelli
% 
% load original image
oim = double(imread('example-im-512x512.png'));

% set options
opts = metamerOpts(oim,'windowType=radial','scale=0.5','aspect=2');

% make windows
m = mkImMasks(opts);

% plot windows
plotWindows(m,opts);

% do metamer analysis on original (measure statistics)
params = metamerAnalysis(oim,m,opts);

% do metamer synthesis (generate new image matched for statistics)
res = metamerSynthesis(params,size(oim),m,opts);