% tf = isnonemptyfield(structure,field)
%
% shortcut function for query:
% if isfield(structure,field) && ~isempty(structure.(field))
%
% in:
%       structure   -   a Matlab structure
%       field       -   a field name (string)
% out:
%       tf          -   whether field is a non-emtpy field of that structure
function tf = isnonemptyfield(structure,field)

tf = 0;
if isfield(structure,field) && ~isempty(structure.(field))
    tf = 1;
end
