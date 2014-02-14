% vis = plotHighdimSample(Sample, dimnames, points, vis)
%
% plots a sample in high dimensional space by showing all different
% 2D-projections of the sample
%
% can, e.g., be used to visualise the posterior samples of a parameter
% distribution, the optional points could then be the true parameter
% values, if they are known
% 
% in: 
%       Sample  -   a sample from a high dimensional space
%                   [nsample, nD] = size
%     dimnames  -   names of the dimensions which are used as axis labels
%                   in the plot (a cell array of strings)
%                   nD = length(dimnames)
%                   [default: {'dim 1', 'dim 2', ...}]
%       points  -   optional, additional set of points which will be
%                   plotted together with the sample
%                   [npoints, nD] = size
%                   [default: []]
%       vis     -   optional visualisation structure which may be provided
%                   in order to plot into a pre-existing figure
% out:
%       vis     -   new or updated visualisation structure with (at least)
%                   the following fields:
%            .fig - handle to figure window
%             .ax - handles to subplots showing the 2D projections
%        .scatter - handles to lineseries objects used to visualise the
%                   sample
%         .points - handles to lineseries objects used to visualise the
%                   additional points
%          .lines - handles to lineseries objects indicating the mean of
%                   the sample with two lines
% author:
%       Sebastian Bitzer (bitzer@cbs.mpg.de)
function vis = plotHighdimSample(Sample, dimnames, points, vis)

nD = size(Sample, 2);
means = mean(Sample);

if nargin < 4
    vis = [];
    if nargin < 3 || isempty(points)
        drawpoints = 0;
    else
        drawpoints = 1;
    end
    if nargin < 2
        dimnames = num2cellstr(1:nD, 'dim %d');
    end
end
vis = initvis(vis);

pointcol = [.8 .1 .1];
scattercol = [.2 .5 .8];
linecol = [0 .3 .6];

nplots = nchoosek(nD, 2);
vis.ax = nan(nplots, 1);
vis.points = nan(nplots, 1);
vis.scatter = nan(nplots, 1);
vis.lines = nan(nplots);

pln = 1;
for d1 = 1:nD-1
    
    for d2 = d1+1:nD
        
        spnum = (d1-1) * (nD-1) + (d2-1);
        vis.ax(pln) = subplot(nD-1, nD-1, spnum);
        hold on
        
        % scatter plot of parameter samples
        vis.scatter(pln) = plot(Sample(:, d1), Sample(:, d2), '.');
        
        % plot extra points as stars
        if drawpoints
            vis.points(pln) = plot(points(:, d1), points(:, d2), '*');
        end
        
        % mean
        xl = xlim;
        yl = ylim;
        vis.lines(pln, :) = plot([xl(1), means(d1) * ones(1,2)] , ...
            [means(d2) * ones(1,2), yl(1)]);
        
        % move mean lines to top
        uistack(vis.lines(pln), 'top')
        
        % labels
        xlabel(dimnames{d1})
        ylabel(dimnames{d2})
        
        pln = pln + 1;
    end
end

set(vis.scatter, 'Color', scattercol)
set(vis.lines, 'Color', linecol)
set(vis.points, 'Color', pointcol)