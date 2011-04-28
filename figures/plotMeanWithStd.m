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
%                   [nt,1] = size, [default: (1:nt)']
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

if nargin==3
    vis = initvis(vis);
else
    vis = initvis([]);
end
hold on
if ~isfield(vis,'mean')
    vis.mean = [];
    vis.stdshade = [];
end

if nargin<2 || isempty(xx)
    xx = (1:nt)';
end

if ndps==1
    warning('matlabHelpers:singleTrial','Only plotting one trial.')
    mu = data;
    shaded = false;
else
    mu = mean(data);
    stdev = std(data);
    
    X = [xx;xx(end:-1:1)];
    Y = [mu+2*stdev, mu(end:-1:1)-2*stdev(end:-1:1)]';
    vis.stdshade(end+1) = fill(X,Y,[.9 .9 .9],'LineStyle','none','EdgeColor',[.7 .7 .7]);
    shaded = true;
end
vis.mean(end+1) = plot(xx,mu,'k');

% make sure the shading is in background
if shaded
    handles = get(gca,'Children');
    set(gca,'Children',handles([1,3:end,2]));
end
