% colors = genDiffColors(cmap,n)
% 
% chooses n maximally different colors from cmap
% in:
%       cmap    -   a colormap
%       n       -   number of requested different colors
% out:
%       colors  -   approximately equidistant colors spanning the whole
%                   range of colors provided in cmap
function colors = genDiffColors(cmap,n)

cstep = (size(cmap,1)-1)/max(n-1,1);
idcs = round(1:cstep:size(cmap,1));
colors = cmap(idcs,:);
