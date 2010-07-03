% X = insConstCols(Xr,colind,colvals)
%
% insert constant value columns, this is the reverse of remConstCols and
% restores the original matrix
%
% in:
%       Xr      -   matrix in which columns should be inserted
%                   [n,m-l] = size
%       colind  -   indeces of columns to be inserted in Xr, note that they
%                   are given in terms of columns in resulting matrix X,
%                   i.e. X(:,colind) selects the constant columns in result
%                   [1,l] = size
%       colvals -   the values that the inserted columns should take
%                   [1,l] = size
% out:
%       X       -   matrix with inserted columns
%                   [n,m] = size
function X = insConstCols(Xr,colind,colvals)

ind = 1:size(Xr,2)+length(colind);
X(:,colind) = repmat(colvals,size(Xr,1),1);
X(:,setdiff(ind,colind)) = Xr;
