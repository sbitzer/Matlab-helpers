% resizeFig(fig,newsize)
%
% resizes a figure window by updating its 'Position' property
%
% in:
%       fig     -   handle to figure
%       newsize -   desired new size of figure window
%                   newsize(1) = width
%                   newsize(2) = height
function resizeFig(fig,newsize)

pos = get(fig,'Position');
pos(3:4) = newsize;
set(fig,'Position',pos)
