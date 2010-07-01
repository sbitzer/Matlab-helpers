% vis = plotCuboidFromLimits(cubelim,cols,vis)
% 
% plots a cuboid from its 3D limits
%
% in:
%       cubelim -   extent of cuboid in each dimension given as lower and
%                   upper limit
%                   cubelim(1,1:3) - lower limit
%                   cubelim(2,1:3) - upper limit
%       cols    -   color of patches drawn for the cuboid, see
%                   FaceVertexCData property of patch for details,
%                   easiest, just set a single color, i.e. cols is scalar,
%                   or [1,3] = size(cols)
%       vis     -   visualisation structure potentially already containing
%                   handles to graphics objects, in particular, if it has
%                   field .fig this figure is used to plot the points into,
%                   [default: []]
% out:
%       vis     -   updated visualisation structure with handle to patch
%                   object in vis.cuboid
function vis = plotCuboidFromLimits(cubelim,cols,vis)

if nargin<3
    vis = initvis([]);
else
    vis = initvis(vis);
end

if nargin<2 || isempty(cols)
    cols = [.9 .9 .9];
end
cols = expandColours(cols,6);

V = [cubelim(2,1) cubelim(2,2) cubelim(2,3); ...
     cubelim(1,1) cubelim(2,2) cubelim(2,3); ...
     cubelim(1,1) cubelim(1,2) cubelim(2,3); ...
     cubelim(2,1) cubelim(1,2) cubelim(2,3); ...
     cubelim(2,1) cubelim(2,2) cubelim(1,3); ...
     cubelim(1,1) cubelim(2,2) cubelim(1,3); ...
     cubelim(1,1) cubelim(1,2) cubelim(1,3); ...
     cubelim(2,1) cubelim(1,2) cubelim(1,3)];

F = [1 2 6 5; ...
     2 3 7 6; ...
     3 4 8 7; ...
     4 1 5 8; ...
     1 2 3 4; ...
     5 6 7 8];
 
vis.cuboid = patch('Vertices',V,'Faces',F,'FaceVertexCData',cols,...
                   'FaceColor','flat');
