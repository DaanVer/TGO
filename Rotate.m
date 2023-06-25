% input: mesh, rotationpoint, rotation angle, rotation axis
% output: rotated mesh around specified axis

function [meshR] = Rotate(mesh,rp,a,axis)
% Load the mesh consisting of points and a connectivity list
points = mesh.Points;
connectivity = mesh.ConnectivityList;

% Translate the mesh so that the point is at the origin
points = points - rp;

% Define rotationmatrix for rotation around chosen axis
if axis == "x"
    R = rotx(a);
elseif axis == "y"
    R = roty(a);
elseif axis == "z"
    R = rotz(a);
else
    disp('ERROR: Input axis is not equal to x, y or z')
    return
end

% Apply the rotation matrix to each point
points = points * R;

% Translate the mesh back to its original position
points = points + rp;

% Regroup connectivity and points to triangulation mesh
meshR = triangulation(connectivity,points);
end