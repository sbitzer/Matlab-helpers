% Q = quantiles(Data, qprobs)
%
% computes quantiles of a data set
%
% in:
%       Data    -   a data vector
%                   N = length
%       qprobs  -   a vector of quantile probabilities defining which 
%                   quantiles to return (a quantile probability is the
%                   desired value of the cumulative density function)
%                   M = length
% out:
%       Q       -   the quantiles (data values which correspond to the
%                   given quantile probabilities)
%                   M = length
% author:
%       Sebastian Bitzer (bitzer@cbs.mpg.de)
function Q = quantiles(Data, qprobs)

N = length(Data);
Data = sort(Data);

cdf = (.5:N) / N;

Q = interp1([0 cdf 1], Data([1,1:end,end]), qprobs);