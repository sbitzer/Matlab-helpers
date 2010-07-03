% this script tries to evaluate the code in variable licensedcode which
% depends on availability of a Matlab toolbox license, if this is not
% available it will wait for 30 seconds and then tries again until it can
% execute the code
% needs:
%       licensedcode    -   a string containing Matlab code
checkouterr = 1;
while checkouterr
    try 
        eval(licensedcode)
        checkouterr = 0;
    catch licenseerr
        if strcmp(licenseerr.identifier,'MATLAB:license:checkouterror')
            disp('waiting for 30 seconds ...')
            pause(30)
        else
            clear checkouterr
            rethrow(licenseerr)
        end
    end
end
clear checkouterr licenseerr