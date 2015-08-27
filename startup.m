% nadded = startup(startdir)
%
% This is a recursive routine adding all subdirectories to the path which
% are not hidden (start with . in Linux, have hidden file attribute in
% Windows)
%
% It is intended that this function is located in startdir and is not on
% the path yet, i.e. it's particular to the project directory it lies in. 
% Note that if there is already a startup on the path, the one in the
% current directory overwrites the one in the path. This can be used to
% overwrite the functionality of this function in subdirectories by simply
% providing a different startup function there. However, this has to be
% able to be called with the startdir argument (which then will just be the
% subdirectory that contains the overwriting startup function and therefore
% is equivalent to calling it without argument).
%
% in:
%       startdir    -   the base directory from which you are starting to
%                       add to the path (including startdir), this is
%                       actually mainly provided for internal operation of
%                       the function, usual usage is to just call "startup"
%                       without arguments, then the function determines the
%                       directory where startup lies and uses that as
%                       startdir
% out:
%       nadded      -   number of directories added to the path
function nadded = startup(startdir)

olddir = pwd;
if nargin<1
    % add self
    pre = mfilename('fullpath');
    pre = pre(1:end-7);             % remove "startup"
else
    pre = startdir;
end
cd(pre)

addpath(pre,'-end')
nadded = 1;


%% add subdirectories (submodules)
files = dir('.');
nfiles = length(files);
[dirs{1:nfiles}] = deal(files.isdir);
dirs = find(cell2mat(dirs));

for d = dirs(3:end)
    % ignore hidden directories (.dir, windows attrib)
    [stat,attrib] = fileattrib(files(d).name);
    if files(d).name(1)~='.' && (isnan(attrib.hidden) || ~attrib.hidden)
        cd(files(d).name)
        nadded = nadded + startup(fullfile(pre,files(d).name));
        cd(pre)
    end
end


%% go to original directory
cd(olddir)
