function [meshR] = rotate_custom_axis(mesh, point1, point2, a)

points = mesh.Points;
connectivity = mesh.ConnectivityList;

points = points - point1;

% Rotation axis from 2 points
Rotaxis = point2 - point1;

a = deg2rad(a);

% Create rotationmatrix
RMH = makehgtform('axisrotate', Rotaxis, a);

RM = RMH(1:3,1:3);

% Apply the rotation matrix to each point
points = points * RM;

points = points + point1;

% Remake mesh
meshR = triangulation(connectivity,points);
end