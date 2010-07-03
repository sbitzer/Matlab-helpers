% Cstr = num2cellstr(A,numform)
%
% converts a numerical array into a cell string, this is particularly
% useful for generating legends from parameter vectors
%
% in:
%       A       -   array containing numerical values
%                   [n,m] = size
%       numform -   number format to use, this is directly given to sprintf
%                   so see there for further explanation, e.g. you can use
%                   'm=%1.2f' to convert each numerical value in A to a
%                   string which puts 'm=' before the value and prints the
%                   value itself with 2 digits behind the period
% out:
%       Cstr    -   cell string containing the generated strings
%                   [n,m] = size
function Cstr = num2cellstr(A,numform)

C = num2cell(A);
Cstr = cellfun(@(x)sprintf(numform,x),C,'UniformOutput',0);