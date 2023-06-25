
% input: plaat en post_op surgical window STL files 
% output: kortste afstand van plaat naar tuberositas en van plaat naar
% condyle 

function[distance_plate_tuberositas, distance_plate_condyle, tuberositas, condyle] = parameter_tuber_condyle_to_plate(plate, tibia_surg_window) 


%% lengte surgical window 
hoogsteZ_surg = max(tibia_surg_window.Points(:,3));
laagsteZ_surg = min(tibia_surg_window.Points(:,3));
lengte_surg = hoogsteZ_surg - laagsteZ_surg;

%% tuberositas kant 
Z_hoogte_tuber = lengte_surg*-0.3;
puntvinden = (tibia_surg_window.Points(:,3) > (Z_hoogte_tuber - 0.5)) & (tibia_surg_window.Points(:,3) < (Z_hoogte_tuber + 0.5));
puntje = find((puntvinden) == 1);
tuberositas_selectie = tibia_surg_window.Points(puntje,:);
tuberositas_maxX = max(tuberositas_selectie(:,1));
tuberositas = find((tuberositas_selectie(:,1)) == tuberositas_maxX);
tuberositas = tuberositas_selectie(tuberositas,:);

%% kortste afstand tuberositas naar plaat

P_x = plate.Points(1:end,1);
P_y = plate.Points(1:end,2);
P_z = plate.Points(1:end,3);
 
for i = 1:1:length(plate.Points)
    distance(i,:) = vecnorm([tuberositas(1,1),tuberositas(1,2),tuberositas(1,3)] - [P_x(i),P_y(i),P_z(i)], 2,2);
    [minDistance, indexOfMin] = min(distance);
    closestX(i,:) = P_x(indexOfMin);
    closestY(i,:) = P_y(indexOfMin);
    closestZ(i,:) = P_z(indexOfMin);
    mindistance(i,:) = minDistance;
end

shortest_distance = min(distance);
point_shortest_distance = find((distance) == shortest_distance);
psdt = plate.Points(point_shortest_distance,:); % plate point shortest distance tuberositas

%% afstand tuber naar plaat 
distance_plate_tuberositas = vecnorm([psdt(:,1), psdt(:,2), psdt(:,3)] - [tuberositas(1,1), tuberositas(1,2) tuberositas(1,3)]);

%% medial condyle kant 
range_condyle = lengte_surg.*-0.05;
puntvinden_condyle = (tibia_surg_window.Points(:,3) > (range_condyle - 2)) & (tibia_surg_window.Points(:,3) < (range_condyle + 2));
puntje_condyle = find((puntvinden_condyle) == 1);
condyle_selectie = tibia_surg_window.Points(puntje_condyle,:);
condyle_maxY = max(condyle_selectie(:,2));
condyle_A = find((condyle_selectie(:,2)) == condyle_maxY);
condyle = condyle_selectie(condyle_A,:);

%% kortste afstand condyle plaat 
for k = 1:1:length(plate.Points)
    distance_condyle(k,:) = vecnorm([condyle(1,1),condyle(1,2),condyle(1,3)] - [P_x(k),P_y(k),P_z(k)], 2,2);
    [minDistance_condyle, indexOfMin_condyle] = min(distance_condyle);
    closestX_condyle(k,:) = P_x(indexOfMin_condyle);
    closestY_condyle(k,:) = P_y(indexOfMin_condyle);
    closestZ_condyle(k,:) = P_z(indexOfMin_condyle);
    mindistance_condyle(k,:) = minDistance_condyle;
end

shortest_distance_condyle = min(distance_condyle);
point_shortest_distance_condyle = find((distance_condyle) == shortest_distance_condyle);
psdc = plate.Points(point_shortest_distance_condyle,:); % plate point shortest distance condyle

distance_plate_condyle = vecnorm([psdc(1,1), psdc(1,2), psdc(1,3)] - [condyle(1,1), condyle(1,2) condyle(1,3)]);

%%
% figure
% hold on 
% kleur(tibia_surg_window, plate,[])
% %trimesh(tibia_surg_wind)
% plot3(psdt(1,1), psdt(1,2), psdt(1,3), 'r*', MarkerSize=5)
% plot3(psdc(1,1), psdc(1,2), psdc(1,3), 'r*', MarkerSize=5)
% plot3(tuberositas(1,1),tuberositas(1,2),tuberositas(1,3), 'r*', MarkerSize=5)
% plot3([psdt(1,1) tuberositas(1,1)],[psdt(1,2) tuberositas(1,2)],[psdt(1,3) tuberositas(1,3)],'m')
% plot3(condyle(1,1),condyle(1,2),condyle(1,3),'r*',MarkerSize=5)
% plot3([psdc(1,1) condyle(1,1)],[psdc(1,2) condyle(1,2)],[psdc(1,3) condyle(1,3)],'m')
% %trimesh(plate)
% axis equal
% hold off

end 
