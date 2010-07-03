% [err,errstd] = computeError(X,Xorig,errtype,seq,varx)
% 
% computes error between two data sets
%
% in:
%       X       -   the computed data
%                   [ndps,nd] = size
%       Xorig   -   the original data
%                   [ndps,nd] = size
%       errtype -   the type of error that is to be computed, at the moment
%                   the following variants are implemented:
%                       'SSE'   -   summed squared error, this error will
%                                   return 0 as standard deviation as the
%                                   errors are summed over all data points
%                                   and dimenions, unless seq (see below) 
%                                   is given, then the SSE of each
%                                   individual sequence is computed and its
%                                   average and standard deviation over
%                                   sequences is returned
%                       'nSSE'  -   SSE normalised by the sum of squared
%                                   elements of a centered version of Xorig
%                                   this is taken from procrustes.m in
%                                   statistics toolbox, standard deviation
%                                   as for SSE
%                       'MSE'   -   mean squared error, averaged over
%                                   sequences and then over dimensions
%                       'nMSE'  -   normalised MSE with variants (see seq
%                                   and varx), normalised errors are
%                                   calculated for each dimension
%                                   individually and then averaged
%                  'sumvarnMSE' -   normalised MSE, but normalising
%                                   variance is the sum of variances across
%                                   dimensions
%       seq     -   if data has sequences and seq contains the indices of
%                   the last data point in each sequence, the error is
%                   computed for each sequence individually and then
%                   averaged over sequences (for different length sequences
%                   this may make a difference, also for the nMSE it means
%                   that the variances are computed only within each
%                   sequence)
%                   [default: ndps, or set to [] ]
%       varx    -   custom set variances for the nMSE
%                   [default: [] ], [1,nd] = size
% out:
%       err     -   the computed error as a scalar
%       errstd  -   corresponding standard deviation
function [err,errstd] = computeError(X,Xorig,errtype,seq,varx)

if nargin<4 || isempty(seq)
    seq = [0,size(X,1)];
end

if nargin<5 || isempty(varx)
    computeVar = 1;
else
    computeVar = 0;
end

if seq(1)~=0
    seq = [0,seq];
end

diff2 = (X-Xorig).^2;

nd = size(diff2,2);
nseq = length(seq)-1;

switch lower(errtype)
    case 'sse'   % summed squared error
        sqerr = nan(length(seq)-1,1);
        for i = 2:length(seq)
            ind = seq(i-1)+1 : seq(i);
            sqerr(i-1) = sum(sum((X(ind,:)-Xorig(ind,:)).^2));
        end
        err = mean(sqerr);
        errstd = std(sqerr);
    case 'nsse'
        Xorignorm = sum(sum(bsxfun(@minus,Xorig,mean(Xorig)).^2));
        sqerr = nan(length(seq)-1,1);
        for i = 2:length(seq)
            ind = seq(i-1)+1 : seq(i);
            sqerr(i-1) = sum(sum((X(ind,:)-Xorig(ind,:)).^2));
        end
        sqerr = sqerr / Xorignorm;
        err = mean(sqerr);
        errstd = std(sqerr);
    case 'mse'
        % mean sequence error
        seqerr = 0;
        seqstd = 0;
        for i = 2:length(seq)
            seqerr = seqerr + mean(diff2(seq(i-1)+1:seq(i),:));
            seqstd = seqstd + std(diff2(seq(i-1)+1:seq(i),:));
        end
        seqerr = seqerr/(length(seq)-1);
        seqstd = seqstd/(length(seq)-1);
        % average over dimensions
        err = mean(seqerr);
        errstd = mean(seqstd);
    case 'nmse'
        seqerr = zeros(length(seq)-1,size(diff2,2));
        seqstd = zeros(length(seq)-1,size(diff2,2));
        for i = 2:length(seq)
            sind = seq(i-1)+1:seq(i);
            if computeVar
                varx = var(X(sind,:));
            end

            seqstd(i-1,:) = std(diff2(sind,:))./varx;
            seqerr(i-1,:) = mean(diff2(sind,:))./varx;
        end
        seqstd = mean(seqstd,1);
        seqerr = mean(seqerr,1);
        
        infnanind = find(seqerr==Inf | isnan(seqerr));
        if isempty(infnanind)
            err = mean(seqerr);
            errstd = mean(seqstd);
        else
            warning('computeError:InfNan',...
                ['in dimensions ',sprintf('%d, ',infnanind),'there are NaNs or Infs'])
            err = mean(seqerr(seqerr~=Inf & ~isnan(seqerr)));
            errstd = mean(seqstd(seqerr~=Inf & ~isnan(seqerr)));
        end
    case 'sumvarnmse'
        seqerr = zeros(nseq,1);
        seqstd = zeros(nseq,1);
        for i = 2:nseq+1
            sind = seq(i-1)+1:seq(i);
            if computeVar
                varx = var(X(sind,:));
            end
            
            ind0 = find(varx~=0);
            if length(ind0)==nd
                seqdiff = reshape(diff2(sind,:),length(sind)*nd,1);
                varx = sum(varx);
            else
                warning('computeError:var0',...
                        ['in dimensions ',sprintf('%d, ',setdiff(1:nseq,ind0)),...
                         'variance is 0 in seq ',sprintf('%d',i-1),...
                         'excluding those dimensions from error calculation'])
                seqdiff = reshape(diff2(sind,ind0),length(sind)*length(ind0),1);
                varx = sum(varx(ind0));
            end
            
            seqstd(i-1) = std(seqdiff)./varx;
            seqerr(i-1) = mean(seqdiff)./varx;
        end
        errstd = mean(seqstd,1);
        err = mean(seqerr,1);
end
