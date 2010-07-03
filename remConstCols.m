% [Xr,colind,colvals] = remConstCols(X)
%
% remove columns which contain constant values, see insConstCols to recover
% the old matrix, a column is regarded constant, when its standard
% deviation is smaller than 1e-10
%
% in:
%       X       -   matrix
%                   [n,m] = size
% out:
%       Xr      -   matrix which doesn't have columns with constant values
%                   [n,m-l] = size
%       colind  -   indeces of removed columns in X
%                   [1,l] = size
%       colvals -   the values of the removed columns
%                   [1,l] = size
function [X,colind,colvals] = remConstCols(X)

colind = find(std(X)<1e-10);
colvals = X(1,colind);
X = X(:,setdiff(1:size(X,2),colind));
