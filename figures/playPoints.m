% vis = playPoints(Points,options,vis)
%
% animates a time series of points (e.g. the 3D positions of a set of
% motion capture markers)
%
% in:
%       Points  -   array containing points to play
%                   [npoints,ndims,ntimes] = size
%                   where npoints is number of different points to display,
%                   ndims is either 1, 2 or 3 and ntimes is the number of
%                   time points in the time series
%       options -   options structure with following fields:
%    .framelength - determines pause in s between update of points
%          .color - color in which points should be plotted in RGB values
%                   [default: [0 0 0]]
%.DataAspectRatio - DataAspectRatio passed to figure
%                   [default: nothing done]
%           .view - (3D) view that figure is changed to
%                   [default: nothing done]
%   .pointOptions - structure with formatting instructions for all points
%                   field names are property names and field values the
%                   corresponding values (cf. applyFormat2Fig.m)
%       vis     -   visualisation structure containing handles to existing
%                   objects in plot
%                   [default: []]
% out:
%       vis     -   updated visualisation structure now including handles
%                   to points which are then in position given by
%                   Points(:,:,end)
%       hname   -   cell string containing name of field added to vis
%       Mov     -   Matlab movie, if this output argument is requested, the
%                   animated dots are captured in a Matlab movie
function [vis,hname,Mov] = playPoints(Points,options,vis)

nd = size(Points,2);
if nd<3
    Points(:,nd+1:3,:) = 0;
end

if nargin<3
    vis = [];
end
vis = initvis(vis);

flength = options.framelength;

skel = [];
if isnonemptyfield(options,'skel')
    skel = options.skel;
end

col = [0 0 0];
if isnonemptyfield(options,'color')
    col = options.color;
end

if ~isempty(skel)
    warning('figures:missing_feature','plotting of skeleton not implemented yet')
else
    [vis,hname] = plotPoints(1,Points(:,:,1),col,vis);
end

if isnonemptyfield(options,'pointOptions')
    format.(hname{1}) = options.pointOptions;
    applyFormat2Fig(vis,format)
end

minmax = [min(min(Points,[],3),[],1)', max(max(Points,[],3),[],1)'];
minmax(:,2) = minmax(:,2) + 1e-10;  % to prevent errors for nd<3
xlim(minmax(1,:))
ylim(minmax(2,:))
zlim(minmax(3,:))

if isnonemptyfield(options,'DataAspectRatio')
    set(gca,'DataAspectRatio',options.DataAspectRatio)
end

if isnonemptyfield(options,'view')
    view(options.view)
end

if nargout>2
    Mov = struct('cdata',{},'colormap',{});
end
for i = 1:size(Points,3)
    set(vis.(hname{1}),'XData',Points(:,1,i),...
                         'YData',Points(:,2,i),...
                         'ZData',Points(:,3,i))
    if nargout>2
        Mov(i) = getframe(gcf);
    else
        pause(flength)
    end
end
