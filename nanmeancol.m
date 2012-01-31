% M = nanmeancol(D,dim)
%
% excludes all columns from computation of mean which contain a nan
% 
% it is assumed that the data D is organised such that a series of
% measurements from a dependent variable is stored in the rows of D where
% each extra dimension corresponds to a factor with potentially several
% values (determined by the size of that dimension)
%
% You want to average the measurements stored in the rows over one of the
% other dimensions, but if a measurement contains a nan it should be
% excluded from the average. In contrast to nanmean of the statistics
% toolbox, here you exclude all measurements in the column, not only the
% single nan.
%
% in:
%       D   -   a data array with maximally 3 dimensions
%               [nt,nf1,nf2] = size
%       dim -   dimension (factor) over which to average, either 2, or 3
% out:
%       M   -   averaged data where all time series (columns) have been
%               excluded which contain at least one nan
%               [nt,1,nf2] = size, if dim=2, or
%               [nt,nf1,1] = size, if dim=3
%       num -   number of time series which have been averaged
%               [1,nf1] = size, if dim=3, or
%               [1,nf2] = size, if dim=2
function [M,num] = nanmeancol(D,dim)

nonanind = ~any(isnan(D));

if dim == 2
    nf2 = size(D,3);
    num = nan(1,nf2);
    M = nan(size(D,1),1,nf2);
    for i = 1:nf2
        num(i) = sum(nonanind(1,:,i));
        M(:,1,i) = mean(D(:,nonanind(1,:,i),i),dim);
    end
elseif dim == 3
    nf1 = size(D,2);
    num = nan(1,nf1);
    M = nan(size(D,1),nf1);
    for i = 1:nf1
        num(i) = sum(nonanind(1,i,:));
        M(:,i) = mean(D(:,i,nonanind(1,i,:)),dim);
    end
end
