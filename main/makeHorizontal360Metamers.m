%This script generates a series of 360 image metamers for a given input
%with focal points spaced out horizontally across the equator.
%Current version requires 1024x2048 equirectangular input image.
oim = double(imread('passau.png'));
assert(isequal(size(oim), [1024, 2048]));

originY = 512.5;
% Produce 1 image per degree along the equator.
angleStepSize = deg2rad(1);
pixelStepSize = 2048 * (angleStepSize/(2*pi));

%for i = -20:1:20
for i = 0:20
    originX = 1024.5 + (pixelStepSize*i);
    makeMetamer360SubIm(oim, [originY,originX], sprintf('metamerAngle%d.png', i));
end
