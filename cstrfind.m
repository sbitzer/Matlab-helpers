% idcs = cstrfind(cstr, substr)
% 
% returns indeces of a cell string which contain the search string which
% can be a regular expression
% in:
%       cstr    -   cell array of strings
%       substr  -   search string, if cell string, makes or-search
%                   over all strings in cell
% out:  
%       idcs    -   indeces of strings in cstr containing substr
function idx = cstrfind(cstr, substr)

if (iscellstr(substr))
    idx = zeros(1,0);
    for i=1:length(substr)
        tmp = find(~cellfun('isempty',regexp(cstr,substr{i})));
        idx = [idx,tmp(:)'];
    end
    idx = unique(idx);
else
    idx = find(~cellfun('isempty',regexp(cstr,substr)));
    idx = idx(:)';
end
