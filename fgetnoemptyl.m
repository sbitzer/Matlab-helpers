% str = fgetnoemptyl(fid)
%
% equivalent to fgetl, but skips empty lines and removes leading
% and trailing white spaces
%
% in:
%       fid     -   file id from fopen
% out:
%       str     -   non empty line from file
function str = fgetnoemptyl(fid)

str = fgetl(fid);
if strcmp(str,'')
    str = fgetnoemptyl(fid);
end

str = strtrim(str);