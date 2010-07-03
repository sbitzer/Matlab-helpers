% bcstr = breakStr(linelength,str1,str2,...)
%
% break a long string into several lines such that it can be
% displayed in the command window without scrolling
%
% in:
%       linelength  -   maximum number of characters on one line
%                       if isempty, = size of Matlab command window
%       str1, ...   -   variable number of input strings, usually char
%                       vectors, but may also be char arrays with 
%                       multiple lines
% out:
%       bcstr       -   broken strings in cell array containing a left 
%                       aligned char array for each input string
function bcstr = breakStr(linelength,varargin)

if isempty(linelength)
    linelength = get(0,'CommandWindowSize');
    linelength = linelength(1);
end

bcstr = cell(1,nargin-1);
for j = 1:nargin-1

    str = varargin{j};

    lstr = numel(str);
    str = reshape(str',1,lstr);
    spaceI = strfind(str,' ');

    % find where to break the string
    i = 1;
    breaks = 1;
    while breaks(i)+linelength<=length(str)
        ind = find(spaceI>breaks(i) & spaceI<=breaks(i)+linelength);
        ind = spaceI(ind(end));

        i = i+1;
        breaks(i) = ind;
    end

    % break the string and fill up array with blanks
    if length(breaks)>1
        strlen = max([diff(breaks),lstr-breaks(end)]);
        bstr = repmat(blanks(strlen),length(breaks),1);
        bstr(1,:) = [str(breaks(1):breaks(2)-1),blanks(strlen-breaks(2)+1)];
        for i = 3:length(breaks)
            len = breaks(i)-1 - (breaks(i-1)+1) + 1;
            bstr(i-1,:) = [str(breaks(i-1)+1:breaks(i)-1),blanks(strlen-len)];
        end
        last = str(breaks(end)+1:end);
        bstr(end,:) = [last,blanks(strlen-length(last))];
    else
        bstr = str;
    end

    bcstr{j} = bstr;
end