% X = gausscdfinv(P, mu, sigma)
%
% implements the inverse of the CDF of the univariate Gaussian distribution
% as given through:
%   http://www.wolframalpha.com/input/?i=gaussian+inverse+cdf
%
% in:
%       P   -   CDF values which should be inverted
%       mu  -   mean
%               [default: 0]
%     sigma -   standard deviation
%               [default: 1]
% out:
%       X   -   X values corresponding to P, same size as P
% author: 
%       Sebastian Bitzer (bitzer@cbs.mpg.de)
function X = gausscdfinv(P, mu, sigma)

if nargin < 3
    sigma = 1;
end
if nargin < 2
    mu = 0;
end

X = mu - sqrt(2) * sigma * erfcinv(2 * P);