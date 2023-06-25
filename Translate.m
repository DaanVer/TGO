% input: plaat, middelpunt translatie, translatie afstand (of transleer naar dat punt: dan x = "max") en as/vlak om langs te transleren
% output: getransleerde plaat

function [meshT]=Translate(mesh,tp,platepoint,axisORplane)
% Load the mesh consisting of points and a connectivity list
points = mesh.Points;
connectivity = mesh.ConnectivityList;


% Vector from centre to translationpoint
V = tp - platepoint;


if axisORplane == "x"
    V(1,2) = 0;
    V(1,3) = 0;
elseif axisORplane == "y"
    V(1,1) = 0;
    V(1,3) = 0;
elseif axisORplane == "z"
    V(1,1) = 0;
    V(1,2) = 0;
elseif axisORplane == "xy"
    V(1,3) = 0;
elseif axisORplane == "yz"
    V(1,1) = 0;
elseif axisORplane == "xz"
    V(1,2) = 0;
elseif axisORplane == "xyz"
else
    disp('ERROR: axis or plane to translate in is not entered properly')
    return
end

points = points + V; % Translate points

meshT = triangulation(connectivity,points); % Remake translated mesh

end