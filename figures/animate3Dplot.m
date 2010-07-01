% F = animate3Dplot(fig,r,mov)
%
% animates plot by rotating the camera around the
% center, optionally a movie is returned containing
% the single frames from the animation
% in:
%       fig -   figure handle
%       r   -   number of full rotations, r is real
%               in [0,inf], 1 = 360°
%       mov -   should frames be stored? {0,1} [optional]
% out:
%       F   -   frame structure array, 
%               empty frame structure, if frames not stored
% author:
%       Sebastian Bitzer (s.bitzer@ucl.ac.uk)
function F = animate3Dplot(fig,r,mov)

if nargin<3
    mov = 0;
end

figure(fig);

F = struct('cdata',{},'colormap',{});
for i=1:round(360*r)
    if (mov)
        F(i) = getframe(fig);
    else
        pause(0.05)
    end
    camorbit(1,0);
end