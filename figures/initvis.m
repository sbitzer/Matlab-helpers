% function vis = initvis(vis)
%
% checks whether vis is a visualisation handle structure, finds the figure
% window in it and makes it the current figure, if it's not a visualisation
% handle structure, it makes one and returns it
%
% in:
%       vis     -   either a structure with at least field
%                       .fig - handle to figure window
%                   or a 1x1 array containing the handle to a figure window
%                   or an empty array
%       pos     -   desired position of figure window, just set Position
%                   property of figure window
%                   [1,4] = size
%                   [default: [] (position not set)]
% out:
%       vis     -   a structure with all fields from input vis with
%                   potentially .fig added
function vis = initvis(vis,pos)

if isempty(vis)
    vis.fig = figure;
elseif isstruct(vis) 
    if isnonemptyfield(vis,'fig')
        set(0, 'CurrentFigure', vis.fig)
    else
        vis.fig = figure;
    end
else
    fig = vis;
    set(0, 'CurrentFigure', fig);
    clear vis
    vis.fig = fig;
end

if nargin>1 && ~isempty(pos)
    set(vis.fig,'Position',pos)
end