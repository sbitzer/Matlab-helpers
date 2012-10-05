% ind = sampleMultinomial(probs, N, options)
%
% samples from a multinomial distribution
% algorithm from Wikipedia
%
% in:
%       probs   -   probabilities defining the distribution
%                   k = length
%       N       -   the desired number of samples
%       options -   currently not used
% out:
%       ind     -   sampled indices of probs
%                   [N,1] = size
% author:
%       Sebastian Bitzer
function ind = sampleMultinomial(probs, N, options)

[sprobs, sind] = sort(probs, 'descend');

sprobs = cumsum(sprobs);

ind = nan(N,1);
rands = rand(N,1);
for i = 1:N
    gind = find(sprobs >= rands(i));
    ind(i) = sind(gind(1));
end
