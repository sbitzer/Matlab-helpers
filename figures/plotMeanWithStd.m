% vis = plotMeanWithStd(data,xx,vis)
%
% plots the mean of given sequential data and a shaded region around it 
% which corresponds to 2*standard deviation
% 
% also supports that mean and standard deviation are directly provided, see
% description of argument 'data'
% 
% in:
%       data    -   either: a matrix containing sequential data, 
%                       independent samples are in rows
%                       [ndps,nt] = size
%                       then mean and standard deviation are computed from
%                       the provided data
%                   or: a cell array with two cells of which the first
%                       contains the means and the second the standard
%                       deviations for all time points
%                       [1,nt] = size(data{i})
%       xx      -   x-positions of data points
%                   [nt,1] = size, [default: (1:nt)']
%       vis     -   visualisation structure containing handles to
%                   graphics objects, only used if has field .fig which is
%                   then used to plot into the given figure
%     hnamemean -   name of field in vis in which handle to mean is put
%      hnamestd -   name of field in vis in which handle to std is put
% out:
%       vis     -   visualisation structure containing handles to
%                   graphics objects, fields:
%            .fig - figure window in which has been plotted
%       .hnamestd - fill area representing 2*standard deviation of data
%      .hnamemean - line representing the mean of data
function vis = plotMeanWithStd(data, xx, vis, hnamemean, hnamestd)

if iscell(data)
    mu = data{1};
    stdev = data{2};
    ndps = Inf;
    nt = numel(mu);
else
    [ndps,nt] = size(data);
    mu = mean(data);
    stdev = std(data);
end

if nargin<2 || isempty(xx)
    xx = (1:nt)';
end

if nargin<3
    vis = initvis([]);
else
    vis = initvis(vis);
end

if nargin<4
    hnamemean = 'mean';
end
if nargin<5
    hnamestd = 'stdshade';
end

if ~isfield(vis,hnamemean) || ~isfield(vis,hnamestd)
    vis.(hnamemean) = [];
    vis.(hnamestd) = [];
end

X = [xx;xx(end:-1:1)];
Y = [mu+2*stdev, mu(end:-1:1)-2*stdev(end:-1:1)]';
vis.(hnamemean)(end+1) = plot(xx,mu,'k');
hold on
if ndps>1
    vis.(hnamestd)(end+1) = fill(X,Y,[.9 .9 .9],'LineStyle','none','EdgeColor',[.7 .7 .7]);
else
    warning('Only plotting one trial.')
    vis.(hnamestd)(end+1) = [];
end

% make sure the shading is in background
handles = get(gca,'Children');
set(gca,'Children',[handles(2:end);handles(1)]);
