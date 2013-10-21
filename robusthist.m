% [barh, lohix, counts, xbars] = robusthist(x, nbin, lohiq)
%
% plots histograms in which extremely small or large values are captured
% in flanking bins with a different colour, extreme values are defined via
% the quantiles of the sampled distribution
%
% This is to make histograms of very heavy-tailed distributions more
% informative. hist.m would produce very wide bins. Then a lot of the
% interesting parts of the distribution may be hidden, because of the low
% bin resolution. histc.m allows to exclude large values, or to make bins
% with different widths. Excluding is not good, because then the heavy tail
% is hidden, and different bin widths look ugly. So here you can at least
% see how many data points are in the tail, but maintain a tidy look of the
% remaining distribution.
%
% Tails of the distribution are defined via a lower and an upper quantile.
% From these a lower (xmin) and upper (xmax) data value is 
% calculated as limits. Then the lower tail of the distribution is defined 
% as all data values x < xmin. The upper tail of the distribution is 
% defined as all data values x >= xmax. Each tail then is represented by
% one bar adjacent to the edges of the bars representing the centre of the
% distribution.
%
% in:
%       x       -   samples from a distribution, a vector
%                   N = length
%       nbin    -   number of bins to display
%       lohiq   -   quantiles used to define the upper and lower tail of
%                   the distribution which should be excluded from 
%                   computing bar widths and positions
%        lohiq(1) - lower quantile
%        lohiq(2) - upper quantile
%                   [default: [0 1]]
% out:
%       barh    -   handles to plotted bar series objects
%         barh(1) - centre of distribution
%         barh(2) - lower tail
%         barh(3) - upper tail
%       lohix   -   data values xmin and xmax corresponding to quantiles 
%                   in lohiq in the provided empirical distribution
%                   = [xmin xmax]
%       counts  -   computed counts for each bin
%                   [1, nbin+1] = size
%       counts(1) - count for lower tail
% counts(2:end-2) - counts for centre of distribution
%   counts(end-1) - count for upper tail
%     counts(end) - count of occurrence of Inf
%       xbars   -   positions of bars on x-axis (centre of bars)
%                   [1, nbin] = size
%        xbars(1) - lower tail bar
%  xbars(2:end-1) - centre bars
%     xbars(nbin) - upper tail bar
% author:
%       Sebastian Bitzer (bitzer@cbs.mpg.de)
function [barh, lohix, counts, xbars] = robusthist(x, nbin, lohiq)

if nargin < 3
    lohiq = [0 1];
end

N = length(x);

% find x-values corresponding to cutoff quantiles
x = sort(x(:))'; 
cdf = (.5 : N) / N;

lohix = nan(1,2);

% lower cutoff
% find empirical quantile closest to lower cutoff quantile
[~, ind] = min((cdf - lohiq(1)).^2);
% find the two empirical quantiles around that, but take care of there
% potentially being no smaller quantile in the data
ind1 = max(ind-1, 1);
ind2 = ind + 1;
% get the data value corresponding to the lower cutoff quantile by
% interpolating between data values of the three empirical quantiles,
% extrapolation is allowed for the case that the cutoff quantile is
% smaller than the smallest empirical quantile
lohix(1) = interp1( cdf(ind1:ind2), ...
    x(ind1:ind2) + (0:1e-12:(ind2-ind1)*1e-12), lohiq(1), 'linear', 'extrap');

% upper cutoff (same idea as for lower cutoff above)
[~, ind] = min((cdf - lohiq(2)).^2);
ind1 = ind - 1;
ind2 = min(ind+1, N);
lohix(2) = interp1( cdf(ind1:ind2), ...
    x(ind1:ind2) + (0:1e-12:(ind2-ind1)*1e-12), lohiq(2), 'linear', 'extrap');

% define bin edges for histc
xbars = linspace(lohix(1), lohix(2), nbin-1);
edges = [-Inf, xbars, Inf];

% define bar centres for bar
dx = xbars(2) - xbars(1);
xbars = [xbars - dx / 2, xbars(end) + dx/2];

% count
counts = histc(x, edges);

% plot histogram
ax = gca;
barh(1) = bar(ax, xbars(1:end-1), counts(1:end-2), 'hist');
hold on
barh(2) = bar(ax, [xbars(1) - dx, xbars(1)], [0, counts(1)], 'hist');
barh(3) = bar(ax, [xbars(end), xbars(end) + dx], counts(end-1:end), 'hist');
set(barh(2:3), 'FaceColor', [.6 .6 .6])