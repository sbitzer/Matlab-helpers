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
%       logp    -   a vector of log-probabilities
% out: 
%       p       -   the vector of normalised probabilities
% author:
%       Sebastian Bitzer
function p = normaliselogprob(logp)

mlogp = max(logp);
logsum = mlogp + log( sum( exp(logp - mlogp) ) );

p = exp( logp - logsum );
