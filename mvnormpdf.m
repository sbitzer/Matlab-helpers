% Y = mvnormpdf(X, mu, C, Cinv, Cdet, logdens)
%
% evaluates the probability density function of the multivariate normal
% distribution (should give same result as mvnpdf.m without actually using
% the statistics toolbox)
%
% Note: currently not optimised for computational efficiency
%
% in:
%       X   -   data matrix containing row vectors for which pdf should be
%               evaluated
%               [N,k] = size
%       mu  -   mean of the normal distribution
%               [1,k] = size
%       C   -   covariance of the normal distribution
%               [k,k] = size
%      Cinv -   inverted covariance, saves computations when provided
%               [k,k] = size
%      Cdet -   determinant of C, saves computations when provided
%               [1,1] = size
%   logdens -   =1, if the log-density should be returned
%               =0 [default], if the density should be returned 
% out:
%       Y   -   probability density evaluated at X
%               [N,1] = size
% author:
%       Sebastian Bitzer
function Y = mvnormpdf(X, mu, C, Cinv, Cdet, logdens)

if nargin < 6
    logdens = 0;
end

k = size(X,2);

if nargin < 5 || isempty(Cdet)
    Cdet = det(C);
end
Z = (2*pi)^(k/2) * sqrt(Cdet);

Xmudiff = bsxfun(@minus, X, mu);

if nargin < 4 || isempty(Cinv)
    XmuCinv = Xmudiff / C;
else
    XmuCinv = Xmudiff * Cinv;
end

if logdens
    Y = -log(Z) - .5 * sum(XmuCinv .* Xmudiff, 2);
else
    Y = exp(-.5 * sum(XmuCinv .* Xmudiff, 2)) / Z;
end
