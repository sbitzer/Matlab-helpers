% len = conseclengths(vec)
%
% in a vector of integers count the number of consecutive elements
%
% in:
%       vec -   a vector of integers
%               nel = length
% out:
%       len -   vector containing numbers of consecutive elements
%               nlen = length, where nlen is the number of sequences of
%               consecutive integers, e.g. if vec = [1,3,4,5,8,9,11],
%               nlen=4 and len = [1,3,2,1], 
%               equal elements are counted as consecutive, e.g. 
%               if vec = [1,1,3,4], len = [2,2]
function len = conseclengths(vec)

diffv = diff(vec);

len = zeros(1,length(find(diffv>1))+1);

cnt = 1;
len(cnt) = 1;
for i = 1:length(diffv)
    if diffv(i)>1
        cnt = cnt + 1;
        len(cnt) = 0;
    end
    len(cnt) = len(cnt) + 1;
end