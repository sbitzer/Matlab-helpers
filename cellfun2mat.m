% M = cellfun2mat(fun,C)
%
% apply function to elements of cell array and transform result to
% matrix, when function is applied to elements of cell array, result
% has to have the same dimensions for each cell independent of the 
% original dimensions of the cell (e.g. like mean(...) when only the 
% size of the first dimension varies across cells)
%
% in:
%       fun -   function to apply to elements of cell array
%       C   -   cell array (vector), nc = length(C)
% out:
%       M   -   matrix with results, [funsize,nc] = size(M)
%               where funsize is the squeezed size of the result of fun
%
% author:
%       Sebastian Bitzer [s.bitzer@ucl.ac.uk]
function M = cellfun2mat(fun,C)

nc = length(C);
n = size(squeeze(fun(C{1})));

cfun = @(Cx)cellfun(@(x)squeeze(fun(x)),Cx,'UniformOutput',false);

M = reshape(cell2mat(cfun(C)),[n,nc]);
