% input: plaat, surgical window en plotten? yes/no
% output: kortste afstand 

function [shortest_distance] = find_shortest_distance_points(points_plate, SW)

% find all points of stl files 

P_x = points_plate(1:end,1);
P_y = points_plate(1:end,2);
P_z = points_plate(1:end,3);
B_x = SW.Points(1:end,1);
B_y = SW.Points(1:end,2);
B_z = SW.Points(1:end,3);

% create matrix  
mindistance = zeros;
closestX = zeros;
closestY = zeros; 
closestZ = zeros;

% find for each point of the plate the shortest distance to the tibia  
for i = 1:1:length(points_plate)
    distance = vecnorm([B_x,B_y,B_z] - [P_x(i),P_y(i),P_z(i)], 2,2);
    [minDistance, indexOfMin] = min(distance);
    closestX(i,:) = B_x(indexOfMin);
    closestY(i,:) = B_y(indexOfMin);
    closestZ(i,:) = B_z(indexOfMin);
    mindistance(i,:) = minDistance;
end

closest_bone_points = [closestX closestY closestZ];

% find the shortest distance (line) of all  
shortest_distance = min(mindistance);
point_shortest_distance = find((mindistance) == shortest_distance);
tsd = closest_bone_points(point_shortest_distance,:); % tibia point shortest distance 
psd = points_plate(point_shortest_distance,:); % plate point shortest distance
end 

