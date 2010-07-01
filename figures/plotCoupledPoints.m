function vis = plotCoupledPoints(points1,cols1,points2,cols2,vis)

if any(size(points1) ~= size(points2))
    error('Point arrays must be same size!')
end

if nargin<5
    vis = [];
end

vis = plotPoints(1,points1,cols1,points2,cols2,vis);

[npoints,nd] = size(points1);
vis.lines1 = nan(npoints,1);
for i = 1:npoints
    pcoup = [points1(i,:);points2(i,:)];
    if nd==2
        vis.lines1(i) = plot(pcoup(:,1),pcoup(:,2),'k:');
    elseif nd==3
        vis.lines1(i) = plot3(pcoup(:,1),pcoup(:,2),pcoup(:,3),'k:');
    else
        error('Only 2 or 3 dimensions supported!')
    end
end
