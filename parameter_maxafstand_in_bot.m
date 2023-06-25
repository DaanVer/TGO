
function [max_afstand_plaat_in_bot] = parameter_maxafstand_in_bot(plate, tibia, tibia_surg_wind)

% clear all 
% close all 
% 
% plate = stlread("Q_plaat_1.stl"); 
% tibia_surg_wind = stlread('Pat1Tibiapostop_SW_nieuw.stl');
% tibia = stlread("Pat1Tibiapostop.stl");

%%

points_plate = plate.Points;

P_x = plate.Points(:,1);
P_y = plate.Points(:,2);
P_z = plate.Points(:,3);
B_x = tibia_surg_wind.Points(:,1); 
B_y = tibia_surg_wind.Points(:,2);
B_z = tibia_surg_wind.Points(:,3);

%%

for i = 1:1:length(points_plate)
    distance = vecnorm([B_x,B_y,B_z] - [P_x(i),P_y(i),P_z(i)], 2,2);
    [minDistance, indexOfMin] = min(distance);
    closestX(i,:) = B_x(indexOfMin);
    closestY(i,:) = B_y(indexOfMin);
    closestZ(i,:) = B_z(indexOfMin);
    mindistance(i,:) = minDistance;
end

closest_bone_points = [closestX closestY closestZ];

%%
IN = inpolyhedron(tibia.ConnectivityList, tibia.Points, plate.Points);
punten_plaat_in_bot = find((IN)  == 1);

% hold on 

punten_bot = closest_bone_points(punten_plaat_in_bot,:);
punten_plaat = points_plate(punten_plaat_in_bot,:);

for k = 1:length(punten_plaat_in_bot)
    afstand_plaat_bot(k,:) = vecnorm([punten_plaat(k,1),punten_plaat(k,2), punten_plaat(k,3)] - [punten_bot(k,1),punten_bot(k,2),punten_bot(k,3)]);
    % plot3([punten_bot(k,1),punten_plaat(k,1)], [punten_bot(k,2), punten_plaat(k,2)], [punten_bot(k,3), punten_plaat(k,3)],'m');
end

max_afstand_plaat_in_bot = max(afstand_plaat_bot);

%% 
% kleur(tibia_surg_wind, plate,[])
%plot3(closest_bone_points(:,1), closest_bone_points(:,2), closest_bone_points(:,3),'m*', 'Markersize', 2)
%plot3(P_x,P_y,P_z,'c*', 'Markersize', 2)
% plot3(punten_bot(:,1),punten_bot(:,2),punten_bot(:,3),'r*', 'Markersize', 2)
% plot3(punten_plaat(:,1),punten_plaat(:,2),punten_plaat(:,3),'b*', 'Markersize', 2)
% axis equal
% view(340, 35);
% zoom(1.5);
% xlim([-50 50]);
% ylim([-50 50]);
% zlim([-150 30]);
% hold off

end 