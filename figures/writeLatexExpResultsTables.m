% writeLatexExpResultsTables(expdata,bestfun,numform,rownames,colnames,fname)
%
% writes experimental results in a latex table (or several), each table
% will have its own "tabular" environment, but no "table" environments are
% generated
%
% in:
%       expdata -   data to write in tables, it is assumed that each row in
%                   expdata contains data from one experiment (or data set)
%                   which has been run in several conditions which need to
%                   be compared, the 3rd array dimension indexes different
%                   entities measured during the experiment each of which
%                   will be written to a separate table
%                   [nds,ncond,ntab] = size
%       bestfun -   function handle to a function which determines which
%                   entries in a matrix are the best, functionality should
%                   be equal to that of max or min in Matlab which is
%                   best(M,[],dim), where dim determines the dimension of
%                   the matrix M along which the comparison should be made,
%                   if you don't want to highlight the best condition in
%                   each column of the tables, make bestfun return values
%                   which do not occurr in expdata
%                   [default: @min]
%       numform -   number format to use for the table entries, see fprintf
%                   for explanation, but only use formats of the type
%                   '%#.#c' where # may be replaced by an integer and c by
%                   a suitable character. This is necessary, because these
%                   formats are used to determine the smallest and largest
%                   numbers to display. Any numbers not falling in this
%                   range will be printed as >= or <= the max or min
%                   values, respectively. Max and min will be determined
%                   based on whether given numbers are positive and
%                   negative and then by using 10^#, -10^#, 10^-# or -10^-#
%                   [default: '%3.2f']
%      rownames -   cell string containing names for the rows (conditions)
%                   ncond = length, [default: []]
%      colnames -   cell string containing names for the columns (data sets)
%                   nds = length, [default: []]
%       fname   -   file name (including path, if necessary) for output,
%                   anything in that file will be overwritten without check
%                   [default: '~/texts/latexExpResutlsTables.tex']
function writeLatexExpResultsTables(expdata,bestfun,numform,rownames,colnames,fname)

[nds,ncond,ntab] = size(expdata);

if nargin<2 || isempty(bestfun)
    bestfun = @min;
end
if nargin<3 || isempty(numform)
    numform = '%3.2f';
end
if nargin<4 || isempty(rownames)
    rownames = cell(1,ncond);
end
if nargin<5 || isempty(colnames)
    colnames = cell(1,nds);
end
if nargin<6 || isempty(fname)
    fname = '~/texts/latexExpResutlsTables.tex';
end

% determine max and min values which are shown for too large or small values
vals = sscanf(numform,'%%%d.%d%c');
if length(vals)~=3
    error('The number format (numform) is not in the desired format!')
end
if min(expdata(:))<0
    minval = -10^vals(1);
else
    minval = 10^-vals(2);
end
if max(expdata(:))>0
    maxval = 10^vals(1);
else
    maxval = -10^-vals(2);
end

fid = fopen(fname,'w');
for tab = 1:ntab
    [best,ind1] = find((expdata(:,:,tab) == repmat(bestfun(expdata(:,:,tab),[],2),[1,ncond]))'); %#ok<NASGU>
    
    fprintf(fid,'\\begin{tabular}{r%s}\n',sprintf(' %c',repmat('r',1,nds)));
    fprintf(fid,'\\hline\n');
    for ds = 1:nds
        fprintf(fid,' & %s',colnames{ds});
    end
    fprintf(fid,'\\\\\n');
    fprintf(fid,'\\hline\n');
    for cond = 1:ncond
        fprintf(fid,'%s',rownames{cond});
        for ds = 1:nds
            if ~isempty(best) && cond == best(ds)
                if expdata(ds,cond,tab) >= maxval
                    fprintf(fid,[' & $\\mathbf{\\geq ',numform,'}$'],maxval);
                elseif expdata(ds,cond,tab) <= minval
                    fprintf(fid,[' & $\\mathbf{\\leq ',numform,'}$'],minval);
                else
                    fprintf(fid,[' & $\\mathbf{',numform,'}$'],expdata(ds,cond,tab));
                end
            else
                if expdata(ds,cond,tab) >= maxval
                    fprintf(fid,[' & $\\geq ',numform,'$'],maxval);
                elseif expdata(ds,cond,tab) <= minval
                    fprintf(fid,[' & $\\leq ',numform,'$'],minval);
                else
                    fprintf(fid,[' & $',numform,'$'],expdata(ds,cond,tab));
                end
            end
        end
        fprintf(fid,'\\\\\n');
    end
    fprintf(fid,'\\end{tabular}\n');
end

fclose(fid);