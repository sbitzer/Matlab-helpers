% F = gausscdf(X, mu, sigma)
%
% implements the CDF of the univariate Gaussian distribution as given on
%   http://en.wikipedia.org/wiki/Gaussian_distribution
%
% in:
%       X   -   values at which CDF should be evaluated
%       mu  -   mean
%               [default: 0]
%     sigma -   standard deviation
%               [default: 1]
% out:
%       F   -   CDF values, same size as X
% author: 
%       Sebastian Bitzer (bitzer@cbs.mpg.de)
function F = gausscdf(X, mu, sigma)

if nargin < 3
    sigma = 1;
end
if nargin < 2
    mu = 0;
end

F = .5 * (1 + erf( (X - mu) / sigma / sqrt(2) ) );