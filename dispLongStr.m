% dispLongStr(lstr)
%
% displays a long string on the command line by breaking it up at suitable
% positions, uses breakStr.m
%
% in:
%       lstr    -   long string to display
function dispLongStr(lstr)

tmp = breakStr([],lstr); 
disp(tmp{:})