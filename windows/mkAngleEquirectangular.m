% IM = mkAngle(SIZE, PHASE, ORIGIN)
%
% Compute a matrix of dimension SIZE (a [Y X] 2-vector, or a scalar)
% containing samples of the roll angle (in radians) of each point in 
% an equirectangular 360 image relative to the given origin point.
%
% Note that the supplied origin point should be a pixel location, not 
% spherical angles.

function [angleIm] = mkAngleEquirectangular(sz,phase,origin)

%Convert input size to 2D if necessary.
sz = sz(:);
if (size(sz,1) == 1)
    sz = [sz, sz];
end

%By default set origin to centre of image.
if (exist('origin') ~= 1)
    origin = (sz+1)/2;
end

if (exist('phase') ~= 1)
    phase = 0;
end

%Matrix containing pixel-space location of each point relative to origin.
imSpaceDiff = meshgrid((1:sz(2))-origin(2), (1:sz(1))-origin(1));

%Generate corresponding location on the sphere for each pixel location
origin_theta = (origin(2) / sz(2)) * 2*pi;
origin_phi = (origin(1) / sz(1)) * pi;
[theta, phi] = meshgrid(linspace(0, 2*pi, sz(2)), linspace(0, pi, sz(1)));

x = cos(theta).*sin(phi);
y = sin(theta).*sin(phi);
z = cos(phi);
coords = cat(3, x, y, z);
origin_coords = [cos(origin_theta).*sin(origin_phi), sin(origin_theta).*sin(origin_phi), cos(origin_phi)];

tmp = ones(1,1,3);
tmp(1,1,:) = origin_coords;
origin_plane_norm = cross(origin_coords, [1, 0, 0]);
origin_plane_norm = origin_plane_norm/norm(origin_plane_norm);
origin_coords = repmat(tmp, sz(1), sz(2), 1);
plane_norms = cross(coords, origin_coords, 3);
plane_norms_lens = vecnorm(plane_norms, 2, 3);
plane_norms_lens = repmat(plane_norms_lens, 1, 1, 3);
plane_norms = plane_norms ./ plane_norms_lens;
tmp = ones(1,1,3);
tmp(1,1,:) = origin_plane_norm;
tmp = repmat(tmp, sz(1), sz(2), 1);
angles = acos(abs(dot(tmp, plane_norms, 3)));

print('a');

