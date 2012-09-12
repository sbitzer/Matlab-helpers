% p = normaliselogprob(logp)
%
% Returns the normalised probabilities of a given set of log-probabilities
% avoiding the representation of the original probabilities to prevent
% numerical underflow. Based on blog-posts by Alex Smola and Alexandre 
% Passos:
% http://blog.smola.org/post/987977550/log-probabilities-semirings-and-floating-point-numbers
% http://atpassos.posterous.com/normalizing-log-probabilities-with-numpy
%
% This is useful, e.g., for model comparison. Assume you store a set of
% log-marginal likelihoods of each model and want to see how they compare
% against each other. Then, this function provides you with an estimate of
% the probability of a model given the data: p(m|D) assuming that the prior
% over model p(m) is uniform.
% 
% in:
%       logp    -   a vector or matrix of log-probabilities, if it is a
%                   vector, it can be any dimension which contains the data
%                   for a matrix it is assumed that data is in 1st dim, ie.
%                   [nx, N] = size, where nx is number of variables to
%                   normalise over and N is the number of distributions to
%                   normalise
% out: 
%       p       -   the vector or matrix of normalised probabilities
%                   [nx, N] = size
% author:
%       Sebastian Bitzer
function p = normaliselogprob(logp)

mlogp = max(logp);
logsum = bsxfun( @plus, mlogp, log( sum( exp( bsxfun(@minus, logp, mlogp) ) ) ) );

p = exp( bsxfun( @minus, logp, logsum ) );
