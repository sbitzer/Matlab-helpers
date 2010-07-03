% [M,OutlierI] = robustmean(X,dim,thresh|OutlierI)
%
% compute a robust version of the mean by detecting outliers and excluding
% them from computing the mean, outliers are detected in the following way:
%
% 1) determine the ratio between median and mean = Md/Me
% 2) outliers which are much larger than other data points:
%    for the means for which abs(Md/Me) is smaller than thresh, these data
%    points are outliers whose absolute value is larger than Me
% 3) equivalent for outliers which are much smaller than other data points:
%    for the means for which abs(Me/Md) is smaller than thresh, these data
%    points are outliers whose absolute value is smaller than Me
%
% example: 
% thresh = 1/3, then if the mean is at least 3 times larger than
% the median, all points are marked as outliers which are at least
% 3 times as big as the median, so the first criterium makes sure
% that there is an outlier situation (and not only a large spread
% of the data) while the second criterium selects potential
% outliers assuming that the scale of the data set without
% outliers is not exceeding 3*median
%
% words of warning: 
% this is a crude heuristics which probably only works for the most obvious
% cases, it certainly breaks down for data sets which have a true mean
% around zero, for a more principled treatment of robust means have a look
% at the following discussion:
% http://www.mathworks.com/matlabcentral/newsreader/view_thread/132060
%
% in:
%       X       -   the data set, a matrix or multidimensional array
%       dim     -   dimension of X over which mean should be computed
%                   [default: first singleton dimension]
%       3rd arg -   may be one of 2 inputs:
%          thresh - threshold to use for outlier detection as described
%                   above, scalar in (0,1)
%        OutlierI - logical array same size as X indicating the positions
%                   of the outliers, when this is given no outliers are
%                   detected, just the given elements are removed from the
%                   data and mean is compputed without them, useful if
%                   outliers are defined by a different variable than the
%                   one corresponding to X
% out:
%       M       -   computed, robust mean
%      OutlierI -   logical array same size as X indicating the positions
%                   of the outliers which have been removed to compute M
function [M,OutlierI] = robustmean(X,dim,thresh)

if nargin<2
    dim = [];
end
if nargin<3
    thresh = 1/3;
end

if isscalar(thresh)
    if isempty(dim)
        Med = median(X);
        Mea = mean(X);
    else
        Med = median(X,dim);
        Mea = mean(X,dim);
    end

    X(  bsxfun(@gt, abs(X), abs(Mea)) ...
      & bsxfun(@plus, zeros(size(X)), abs(Med./Mea)<thresh) ) = NaN;
    X(  bsxfun(@lt, abs(X), abs(Mea)) ...
      & bsxfun(@plus, zeros(size(X)), abs(Mea./Med)<thresh) ) = NaN;

    OutlierI = isnan(X);
    nout = sum(OutlierI(:));
    if nout>0
        warning('robust:outlierdetect','%d outliers detected and removed.',nout)
    end
else                    % thresh is outlier indices
    OutlierI = thresh;
    X(OutlierI) = NaN;
end

if isempty(dim)
    M = nanmean(X);
else
    M = nanmean(X,dim);
end
