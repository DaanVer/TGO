function Points_bot_index_matrix = clickA3DPoint(botmesh)
%CLICKA3DPOINT
%   H = CLICKA3DPOINT(POINTCLOUD) shows a 3D point cloud and lets the user
%   select points by clicking on them. The selected point is highlighted 
%   and its index in the point cloud will is printed on the screen. 
%   POINTCLOUD should be a 3*N matrix, represending N 3D points. 
%   Handle to the figure is returned.
%
%   other functions required:
%       CALLBACKCLICK3DPOINT  mouse click callback function
%       ROWNORM returns norms of each row of a matrix
%       
%   To test this function ... 
%       pointCloud = rand(3,100)*100;
%       h = clickA3DPoint(pointCloud);
% 
%       now rotate or move the point cloud and try it again.
%       (on the figure View menu, turn the Camera Toolbar on, ...)
%
%   To turn off the callback ...
%       set(h, 'WindowButtonDownFcn',''); 
%
%   by Babak Taati
%   http://rcvlab.ece.queensu.ca/~taatib
%   Robotics and Computer Vision Laboratory (RCVLab)
%   Queen's University
%   May 4, 2005 
%   revised Oct 30, 2007
%   revised May 19, 2009

Points_bot = botmesh.Points';

if nargin ~= 1
    error('Requires one input arguments.')
end

if size(Points_bot, 1)~=3
    error('Input point cloud must be a 3*N matrix.');
end

% show the point cloud
h = gcf;
hold on 
plot3(Points_bot(1,:), Points_bot(2,:), Points_bot(3,:), 'k.', 'MarkerSize', 3); 
axis equal

view(-50, -10)
xlim([-50, 10])
ylim([-50, 20])   
zlim([-60, -10])

title('click first point')

% set the callback, pass pointCloud to the callback function
set(h, 'WindowButtonDownFcn', {@callbackClickA3DPoint, Points_bot}); 

pause

plot3(Points_bot(1, Points_bot_index), Points_bot(2, Points_bot_index), Points_bot(3, Points_bot_index), 'g.', 'MarkerSize', 20)
Points_bot_index_matrix(1) = Points_bot_index;
title('Click second point')

pause

plot3(Points_bot(1, Points_bot_index), Points_bot(2, Points_bot_index), Points_bot(3, Points_bot_index), 'g.', 'MarkerSize', 20)
Points_bot_index_matrix(2) = Points_bot_index;
title('Click third point')

pause

plot3(Points_bot(1, Points_bot_index), Points_bot(2, Points_bot_index), Points_bot(3, Points_bot_index), 'g.', 'MarkerSize', 20)
Points_bot_index_matrix(3) = Points_bot_index;
title('thx for clicking')



