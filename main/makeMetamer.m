function res = makeMetamer(oim, opts, masks, initIm)


% do metamer analysis on original (measure statistics)
params = metamerAnalysis(oim, masks, opts);

% do metamer synthesis (generate new image matched for statistics)
if ~exist('initIm', 'var')
    res = metamerSynthesis(params, size(oim), masks, opts);
else
    res = metamerSynthesis(params, initIm, masks, opts);
end
