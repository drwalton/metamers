%% 4-PANEL TEXTURE DEMO (will take <1min per iteration)
%
% This version of the model computes parameters within nine windows that
% tile the image. It is NOT the same as the model used in the paper,
% but runs substantially faster, so is a good way to make sure 
% that the code is working. The resulting synthetic image should reproduce the
% texture of the original within coarse square tiles.

% % load original image
% %oim = double(imread('portico.jpg'));
% 
% % set options
% %opts = metamerOpts(oim,'windowType=square','nSquares=[3 1]');
% 
% % make windows
% m = mkImMasks(opts);
% 
% % plot windows
% plotWindows(m,opts);
% 
% % do metamer analysis on original (measure statistics)
% params = metamerAnalysis(oim,m,opts);
% 
% % do metamer synthesis (generate new image matched for statistics)
% res = metamerSynthesis(params,size(oim),m,opts);


% %% METAMER DEMO (will take a few min per iteration)
% %
% % This version uses windows that tile the image in
% % polar angle and log eccentricity, with parameters 
% % used to generate metamers in Freeman & Simoncelli
% 
% % load original image
% %oim = double(imread('example-im-512x512.png'));
% oim = double(imread('portico.jpg'));
% 
% % set options
% opts = metamerOpts(oim,'windowType=radial','scale=0.5','aspect=2');
% 
% % make windows
% m = mkImMasks(opts);
% 
% % plot windows
% plotWindows(m,opts);
% 
% % do metamer analysis on original (measure statistics)
% params = metamerAnalysis(oim,m,opts);
% 
% % do metamer synthesis (generate new image matched for statistics)
% res = metamerSynthesis(params,size(oim),m,opts);


%% New equirectangular demo
%
% This version uses windows that tile the image in
% polar angle and log eccentricity, with parameters 
% used to generate metamers in Freeman & Simoncelli

% load original image
%oim = double(imread('example-im-512x512.png'));
%oim = double(imread('equirectangular.png'));
%oim = double(imread('washitsu.png'));
oim = double(imread('ny.png'));
%oim = double(imread('equirectangular_big.png'));
%oim = double(imread('portico.jpg'));

% set options
opts = metamerOpts(oim,'windowType=radialEquirectangular','scale=0.5','aspect=2');

% make windows
m = mkImMasks(opts);

% plot windows
plotWindows(m,opts);

% do metamer analysis on original (measure statistics)
params = metamerAnalysis(oim,m,opts);

% do metamer synthesis (generate new image matched for statistics)
res = metamerSynthesis(params,size(oim),m,opts);
