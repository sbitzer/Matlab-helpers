% vis = compareLines(T1,T2,x,vis)
%
% Assumes that two data sets are given which represent different
% versions of the same thing which should be compared. Each column in the
% data matrices will be interpreted as sequential measurements from a
% variable and will be plotted as a line. The corresponding line from the
% other data set gets the same colour, but different line style
% standard setting is that T1 is full lines, T2 lines are dotted use vis
% and applyFormat2Fig to change standard settings after figure generation
%
% in:
%       T1  -   data set (trajectories) 1
%               [ndps,nD] = size
%       T2  -   data set (trajectories) 2
%               [ndps,nD] = size
%       x   -   optional x-values for all lines (e.g. time) in vector
%               [default: 1:ndps], set x=[] to use default when 4th arg given
%               ndps = length(x)
%       vis -   a structure potentially already containing handles to
%               graphics objects, in particular, if it has field .fig
%               this figure is used to plot the points into, this is
%               optional and may be empty
%               can also be a figure handle alone (when no structure)
%               also see initvis.m
% out:
%       vis -   structure with handles to drawn graphics objects
%        .fig - figure handle
%     .lines1 - handles to lines drawn for T1
%               nD = length(lines1)
%     .lines2 - handles to lines drawn for T2
%               nD = length(lines1)
%     note that the numbering of lines1 and lines2 depends on whether there
%     are already lines objects in vis, then lines1 and lines2 will be
%     fields lines3 and lines4, if lines1 and lines2 already existed in vis
function vis = compareLines(T1,T2,x,vis)

[ndps,ntraj] = size(T1);

assert(all([ndps,ntraj]==size(T2)))

if nargin<4
    vis = [];
end
vis = initvis(vis);
if nargin<3 || isempty(x)
    x = 1:ndps;
end
x = x(:);

hold on


%% determine whether there are already lines in figure
poff = 0;   % point set numbering offset
names = fieldnames(vis);
pind = find(cellfun(@(x) ~isempty(x),strfind(names,'lines')));
if ~isempty(pind)
    for i = pind'
        pnum = sscanf(names{i},'lines%d');
        if poff<pnum
            poff = pnum;
        end
    end
end
hnames{1} = sprintf('lines%d',1+poff);
hnames{2} = sprintf('lines%d',2+poff);


%% plot lines
vis.(hnames{1}) = plot(x*ones(1,ntraj),T1);
vis.(hnames{2}) = plot(x*ones(1,ntraj),T2);


%% standard format for lines
% not original
set(vis.(hnames{1}),'LineWidth',2)

% original
set(vis.(hnames{2}),'LineStyle',':','LineWidth',2)