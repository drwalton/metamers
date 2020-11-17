files = dir("*.png");
for i = 1:size(files)
    files(i).name
end

oim = double(imread(files(1).name));
opts = metamerOpts(oim,'windowType=radial','scale=0.5','aspect=2', 'nIters=25');
m = mkImMasks(opts);
metamers = cell(size(files));

outputDir = 'outputNoise';

metamers{1} = makeMetamer(oim, opts, m);
mkdir(outputDir);
imwrite(metamers{1}/255, fullfile(outputDir, files(1).name));

for i = 2:size(files)
    oim = double(imread(files(i).name));
    %initialise with prev image
    %metamers{i} = makeMetamer(oim, opts, m, metamers{i-1});
    %initialise with noise
    metamers{i} = makeMetamer(oim, opts, m);
    imwrite(metamers{i}/255, fullfile(outputDir, files(i).name));
end
