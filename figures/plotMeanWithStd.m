% vis = plotMeanWithStd(data,xx,vis)
%
% plots the mean of given sequential data and a shaded region around it 
% which corresponds to 2*standard deviation
% 
% in:
%       data    -   a matrix containing sequential data, independent 
%                   samples are in rows
%                   [ndps,nt] = size
%       xx      -   x-positions of data points
%                   [ndps,1] = size, [default: (1:nt)']
%       vis     -   visualisation structure containing handles to
%                   graphics objects, only used if has field .fig which is
%                   then used to plot into the given figure
% out:
%       vis     -   visualisation structure containing handles to
%                   graphics objects, fields:
%            .fig - figure window in which has been plotted
%       .stdshade - fill area representing 2*standard deviation of data
%           .mean - line representing the mean of data
function vis = plotMeanWithStd(data,xx,vis)

[ndps,nt] = size(data);

if nargin<2 || isempty(xx)
    xx = (1:nt)';
end

mu = mean(data);
stdev = std(data);

if nargin==3
    vis = initvis(vis);
else
    vis = initvis([]);
end
if ~isfield(vis,'mean')
    vis.mean = [];
    vis.stdshade = [];
end

X = [xx;xx(end:-1:1)];
Y = [mu+2*stdev, mu(end:-1:1)-2*stdev(end:-1:1)]';
vis.mean(end+1) = plot(xx,mu,'k');
hold on
if ndps>1
    vis.stdshade(end+1) = fill(X,Y,[.9 .9 .9],'LineStyle','none','EdgeColor',[.7 .7 .7]);
else
    warning('Only plotting one trial.')
    vis.stdshade(end+1) = [];
end

% make sure the shading is in background
handles = get(gca,'Children');
set(gca,'Children',[handles(2:end);handles(1)]);
