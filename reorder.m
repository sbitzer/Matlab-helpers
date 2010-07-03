% inds = reorder(n1,elems)
% 
% index manipulation: given a vector of consecutive elements, e.g. v=1:12,
% and a set of desired positions for the last n elements, return a vector
% of indices which tells you which element of v is at which position after
% merging the last n elements to the desired positions and the remaining
% elements around it in the order of v
%
% in:
%       n1    - number of elements up to the last n, i.e. n1=length(v)-n
%               e.g. if v=1:12 and n=4, then n1 = 8
%       elems - vector containing desired positions for the last n elements
%               n = length
% out:
%       inds  - indeces to v after reordering, inds(elems(i))=v(n1+i) and
%               all other indeces wrapping around it as fit, 
%               e.g. if   n1=8 and elems=[2:3,6,9], 
%                    then v=1:12 and inds=[1,9,10,2,3,11,4,5,12,6,7,8]
function inds = reorder(n1,elems)

elems = elems(:);

nel = length(elems);
cl = conseclengths(elems);

order = [elems,n1+(1:nel)'];
j = 1;
k = 1;
for i = 1:n1
    order(i+nel,:) = [i+sum(elems<=j),i];
    j = j + 1;
    if ismember(j,elems)
        j = j + cl(k);
        k = k+1;
    end
end

inds = sortrows(order);
inds = inds(:,2);
