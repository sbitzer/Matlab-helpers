% [M, S, N] = nanmeanstd(X, dim)
%
% computes means and standard deviations of a data set while ignoring NaNs
% can be used instead of the statistics toolbox versions to save licences
% 
% in:
%       X   -   data set, general multidimensional array
%       dim -   dimension of X over which statistics should be computed
% out:
%       M   -   means, same dimensions as X, but dim has only 1 entry
%               containing the means
%       S   -   standard deviations, same format as M, computed using the
%               standard definition of S in std.m (divide by N-1)
%       N   -   numbers of data points on which means and stds are based
%               after NaNs are excluded, same format as M
function [M, S, N] = nanmeanstd(X, dim)

if nargin < 2
    dim = 1;
end

nans = isnan(X);
N = sum(~nans, dim);

X0 = X;
X0(nans) = 0;

M = sum(X0, dim) ./ N;

if nargout > 1
    S = bsxfun(@minus, X, M).^2;
    S(nans) = 0;
    S = sqrt( sum(S, dim) ./ (N-1) );
end