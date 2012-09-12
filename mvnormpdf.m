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

Xmudiff = bsxfun(@minus, X, mu);

if nargin < 4 || isempty(Cinv)
    XmuCinv = Xmudiff / C;
else
    XmuCinv = Xmudiff * Cinv;
end

if logdens
    % assuming that C is a proper positive definite covariance matrix, this
    % may happen when there are a lot of small eigenvectors whose product
    % is 0 because the small size cannot be represented numerically, in
    % this case compute the eigenvectors explicitly and sum their logs
    if Cdet == 0
        E = eig(C);
        logCdet = sum(log(E));
    else
        logCdet = log(Cdet);
    end
    Y = -k/2*log(2*pi) - logCdet/2 - .5 * sum(XmuCinv .* Xmudiff, 2);
else
    Z = (2*pi)^(k/2) * sqrt(Cdet);
    Y = exp(-.5 * sum(XmuCinv .* Xmudiff, 2)) / Z;
end
