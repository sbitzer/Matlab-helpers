% handles = fillaxes(ax,col)
%
% puts coloured rectangles on the axis borders, for viewing in Matlab this
% is equivalent with set(gca,'Color',col) when no grid is on, but when
% exporting a figure with exportfig.m the color setting of the axis seems
% to be lost, so this is the work around
%
% NOTE that I have done that in particular for
% dlrarmUpDRConstraintFigures.m and I haven't made it dependent on the view
% so if you change the view, you might have one of the planes covering your
% plot
% 
% in:
%       ax      -   handle to axis which you want to colour in
%       col     -   ColorSpec
% out:
%       handles -   handles to drawn patch objects for the 3 axes
%                   handles(1): bottom
%                   handles(2): left
%                   handles(3): back
function handles = fillaxes(ax,col)

axes(ax)

xl = xlim;
yl = ylim;
zl = zlim;

bottom = [xl(1),yl(1),zl(1);...
          xl(2),yl(1),zl(1);...
          xl(2),yl(2),zl(1);...
          xl(1),yl(2),zl(1);...
          xl(1),yl(1),zl(1)];
      
left   = [xl(1),yl(2),zl(1);...
          xl(2),yl(2),zl(1);...
          xl(2),yl(2),zl(2);...
          xl(1),yl(2),zl(2);...
          xl(1),yl(2),zl(1)];

back   = [xl(2),yl(1),zl(1);...
          xl(2),yl(1),zl(2);...
          xl(2),yl(2),zl(2);...
          xl(2),yl(2),zl(1);...
          xl(2),yl(1),zl(1)];


handles(1) = fill3(bottom(:,1),bottom(:,2),bottom(:,3),col);
handles(2) = fill3(left(:,1),left(:,2),left(:,3),col);
handles(3) = fill3(back(:,1),back(:,2),back(:,3),col);

xlim(xl)
ylim(yl)
zlim(zl)
