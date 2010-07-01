% sc = combineStructs(s1,s2)
%
% combine two structures, if the input structures have common fields, then
% the field values of the first structure will be overwritten with the 
% values of the second structure and a warning that this happened will
% be displayed
%
% in:
%       s1  -   first structure
%       s2  -   second structure
% out:
%       sc  -   combined structure containing all fields from s1 and s2
function sc = combineStructs(s1,s2)

% this makes sure that the for-loop below is over the smaller
% number of fields
fnames = fieldnames(s1);
num = 1;
len = length(fnames);
fnames = fieldnames(s2);
if len>=length(fnames)
    len = length(fnames);
    sc = s1;
else
    num = 2;
    fnames = fieldnames(s1);
    sc = s2;
    s2 = s1;
    s1 = sc;
end

for i=1:len
    if isfield(s1,fnames{i})
        warning('tools:structOverwrite','overwriting s1.%s with s2.%s',...
                                        fnames{i},fnames{i})
        if num==1
            sc.(fnames{i}) = s2.(fnames{i});
        end
    else
        sc.(fnames{i}) = s2.(fnames{i});
    end
end
