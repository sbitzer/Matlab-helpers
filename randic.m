% r = randic(imax,m)
%
% generate pseudorandom vector of integers in which all integers occur a
% given number of times and no two consecutive integers are equal
%
% in:
%       imax -  maximum integer defining the admissible interval 1:imax
%       m    -  number of times each integer should occur in r, may be a
%               scalar (each integer occurs equally frequently), or a
%               vector (each integer occurs with the given number of
%               times), then:
%               [1,imax] = size
% out:
%       r    -  vector of pseudorandom integers
%               [sum(m), 1] = size
% author:
%       Sebastian Bitzer
function r = randic(imax,m)

unsuccessfull = true;
while unsuccessfull
    try
        if numel(m) == 1
            counts = m * ones(1,imax);
        else
            counts = m;
        end
        
        N = sum(counts);
        
        % initial random integer (unconstrained)
        r = [randi(imax,1); nan(N-1,1)];
        counts(r(1)) = counts(r(1)) - 1;
        
        for i = 2:N
            % candidate integers
            candid = 1:imax;
            % remove those excluded by constraints
            consti = [r(i-1), find(counts<=0)];
            candid = setdiff(candid,consti);
            
            % choose random integer
            r(i) = candid(randi(length(candid),1));
            
            % update counts
            counts(r(i)) = counts(r(i)) - 1;
        end
        
        unsuccessfull = false;
    catch err
        if strcmp(err.identifier,'MATLAB:RandStream:randi:invalidLimits')
            % this happens when no admissible conditions are left to choose,
            % because the last 3 conditions belong to either the same task or
            % same semi-tone step size, but the other two conditions cannot be
            % chosen because all of their blocks have already been used
            warning('helpers:restart','Ran in a gridlock when generating pseudorandom integers, restart.')
        else
            rethrow(err)
        end
    end
end
