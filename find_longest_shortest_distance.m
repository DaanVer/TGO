% input: plaat, surgical window en plotten? yes/no
% output: kortste afstand 

function [longest_shortest_distance,mindistance] = find_longest_shortest_distance(points, SW)

% find all points of stl files

P_x = points(:,1);
P_y = points(:,2);
P_z = points(:,3);
B_x = SW.Points(:,1);
B_y = SW.Points(:,2);
B_z = SW.Points(:,3);

% create matrix  
mindistance = zeros;
closestX = zeros;
closestY = zeros; 
closestZ = zeros;

% find for each point of the plate the shortest distance to the tibia  
for i = 1:1:length(points)
    distance = vecnorm([B_x,B_y,B_z] - [P_x(i),P_y(i),P_z(i)], 2,2);
    [minDistance, indexOfMin] = min(distance);
    closestX(i,:) = B_x(indexOfMin);
    closestY(i,:) = B_y(indexOfMin);
    closestZ(i,:) = B_z(indexOfMin);
    mindistance(i,:) = minDistance;
end

% find the longest shortest distance (line) of all  
longest_shortest_distance = max(mindistance);

end 