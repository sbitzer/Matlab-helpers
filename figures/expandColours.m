% cols = expandColours(cols,npoints,expandinds,colmap)
%
% expand given colours either in number or to RGB values, there are several
% possiblities depending on input cols
%
% in:
%       cols    -   colours wich should be expanded
%                   [m,n] = size
%                   m=npoints & n=3: colours already expanded, do nothing
%                   m=npoints & n=1: colours are given as index into
%                                    colormap, if expandinds=1, these
%                                    indeces are expanded into RGB values
%                                    by linearly interpolating between
%                                    colormap values as done in scatter, if
%                                    expandinds=0, nothing is done
%                   m=1 & n=3: expand given colour npoints-times
%                   m=1 & n=1: only a single index into colormap given, if
%                              expandinds=0, nothing is done, else if
%                              0<=index<=1 this index is directly used to
%                              get a corresponding RGB colour out of the
%                              colormap, else 1st RGB colour in colormap is
%                              returned
%       npoints -   number of points for which colours should be expanded
%    expandinds -   =1 if scalar indeces into colormap should be resolved
%                   into RGB values, =0 if not
%                   [default: 1]
%        colmap -   a colormap used for index expansion
%                   [ncolm,3] = size, [default: current figure colormap]
% out:
%       cols    -   colours expanded as given above, sizes can be:
%                   [npoints,3] RGB values for all points
%                   [npoints,1] indeces into colormap (for e.g. scatter)
%                   [1,3] common RGB value for all points
%                   [1,1] common index into colormap for all points
%                   if single colours are given as input they are not
%                   expanded to all points, because the plotting commands
%                   usually do that themselves
function cols = expandColours(cols,npoints,expandinds,colmap)

if nargin<3             % determines whether to expand indeces into the 
    expandinds = 1;     % colourmap (when using this, change of colormap
end                     % has no effect when using scatter)
                        
if nargin<4
    colmap = colormap;
end
ncolm = size(colmap,1);

[m,n] = size(cols);

if m==npoints && n==3
    % do nothing
elseif m==1 && n==1
    if expandinds
        if cols<0 || cols>1
            cols = colmap(1,:);
        else
            ncolm = size(colmap,1);
            cols = interp1((0:ncolm-1)/(ncolm-1),colmap,cols);
            cols = min(max(cols,zeros(size(cols))),ones(size(cols)));
        end
    end
elseif m==npoints && n==1  % linearly interpolate into colormap
    if expandinds
        cols = cols-min(cols);
        cols = cols/max(cols);
        cols = interp1((0:ncolm-1)/(ncolm-1),colmap,cols);
        cols = min(max(cols,zeros(size(cols))),ones(size(cols)));
    end
elseif m==1 && n==3         % all the same colour
    cols = repmat(cols,npoints,1);
else
    error('Colour format not recognised!')
end