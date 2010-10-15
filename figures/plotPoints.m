% vis = plotPoints(meth,varargin)
%
% plot point clouds in 2D or 3D, gives you 3 alternatives of doing it:
%       1)  plot each set of points as one line object, this is efficient
%           and allows to draw lines between the points in the order they
%           are given in the arrays, but it has problems with occlusions
%           and intersections with planes (apparently some openGL issues)
%       2)  plot every point separately, i.e. each given point will be its
%           own line object, this allows you to colour each point
%           separately and it solves the occlusion issues of 1), but it's
%           quite inefficient and not recommendable for larger point sets
%       3)  use scatter to plot the points, this is the efficient way of
%           plotting many points with different colours, it also seems to
%           solve the occlusion problems of 1), downside is that points are
%           drawn as patch objects which do not support RGB colours in the
%           painter (renderer) mode, this means that a plot with custom set
%           colours will not export as vector graphics
%           currently you can't set the sizes of the points by calling this
%           function (set to 30 for all), but you can use the returned
%           handle to do that afterwards, if needed
%
% in:
%       meth    -   choose 1,2 or 3 from above
%       points1 -   a set of 3D data points
%                   [npoints1,3] = size
%       cols1   -   colours for the data points, can be given in 1 of 4
%                   ways: 
%                       a)  as a full set of RGB colour specs, then 
%                           [npoints1,3] = size
%                       b)  as a single RGB colour spec, then
%                           [1,3] = size, and all points get this colour
%                       c)  as scalar values indexing the current colourmap
%                           [npoints1,1] = size, this is equivalent to
%                           scatter's C input and it's directly passed
%                           through to scatter in 3) meaning that colours
%                           will change with colormap, for 1) and 2) this
%                           is not the case
%                       d)  as a single scalar index into the colourmap, if
%                           that scalar falls within 0<=x<=1 it is assumed
%                           to be a direct index into the colourmap,
%                           selecting the corresponding colour, if it is
%                           out of this region, the first colour of the
%                           colourmap is chosen for all data points
%       points2 -   another set of points
%       cols2   -   as above
%       ...
%       vis     -   a structure potentially already containing handles to
%                   graphics objects, in particular, if it has field .fig
%                   this figure is used to plot the points into, this is
%                   optional and may be empty
%                   can also be a figure handle alone (when no structure)
% out:
%       vis     -   structure with handles to drawn graphics objects
%            .fig - figure handle
%             .ax - axis handle
%        .points1 - for 1) this is a handle to one line object for points1,
%                   for 2) this is a vector of line object handles
%                   for 3) this is a handle to a group of patch objects
%                   each point in points1
%        .points2 - as above
%           ...
%   handlenames -   cell string
%                   names of fields that have been added to vis containing
%                   the handles of the plotted points, this is returned, 
%                   because, if there were already points in the figure, it
%                   is otherwise not easy to know which are the handles
%                   that have just been added (e.g. vis.points4)
%                   [1,number of point data sets] = size
function [vis,handlenames] = plotPoints(meth,varargin)

nvarin = nargin-1;

if mod(nvarin,2)==1    % if 1 more input than expected num of data with colours
    vis = varargin{end};
    varargin = varargin(1:end-1);
    nvarin = nvarin - 1;
    vis = initvis(vis);
else
    vis = initvis([]);
end
if mod(nvarin,2)==1
    error('Unexpected number of inputs!')
end

nsets = nvarin/2;

hold on

% determine whether there are already points in figure
poff = 0;   % point set numbering offset
names = fieldnames(vis);
pind = find(cellfun(@(x) ~isempty(x),strfind(names,'points')));
if ~isempty(pind)
    for i = pind'
        pnum = sscanf(names{i},'points%d');
        if poff<pnum
            poff = pnum;
        end
    end
end

handlenames = cell(1,nsets);
for i = 1:nsets
    handlenames{i} = sprintf('points%d',i+poff);
end

switch meth
    case 1 % points from one array together
        for i = 1:nsets
            points = varargin{2*(i-1)+1};
            cols = varargin{2*(i-1)+2};
            cols = expandColours(cols,1);
            
            nd = size(points,2);
            if nd==3
                vis.(handlenames{i}) = ...
                    plot3(points(:,1),points(:,2),points(:,3),'.','Color',cols(1,:));
            elseif nd==2
                vis.(handlenames{i}) = ...
                    plot(points(:,1),points(:,2),'.','Color',cols(1,:));
            else
                error('Only 2 or 3 dimensions supported!')
            end
        end
    case 2 % every point separately
        for i = 1:nsets
            points = varargin{2*(i-1)+1};
            [npoints,nd] = size(points);
            cols = varargin{2*(i-1)+2};
            cols = expandColours(cols,npoints);
            
            vis.(handlenames{i}) = nan(npoints,1);
            for p = 1:npoints
                if nd==3
                    vis.(handlenames{i})(p) = ...
                        plot3(points(p,1),points(p,2),points(p,3),'.','Color',cols(p,:));
                elseif nd==2
                    vis.(handlenames{i})(p) = ...
                        plot(points(p,1),points(p,2),'.','Color',cols(p,:));
                else
                    error('Only 2 or 3 dimensions supported!')
                end
            end
        end
    case 3 % scatter
        for i = 1:nsets
            points = varargin{2*(i-1)+1};
            cols = varargin{2*(i-1)+2};
            cols = expandColours(cols,size(points,1),0);
            
            nd = size(points,2);
            if nd==3
                vis.(handlenames{i}) = ...
                    scatter3(points(:,1),points(:,2),points(:,3),30,cols,'.');
            elseif nd==2
                vis.(handlenames{i}) = ...
                    scatter(points(:,1),points(:,2),30,cols,'.');
            else
                error('Only 2 or 3 dimensions supported!')
            end
        end
end

