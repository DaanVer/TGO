% input: plaatmesh, botmesh 
% output: afstand tibiaplateau tot bovenste punt plaat 

% botmesh = stlread("Pat1Tibiapostop_SW_nieuw.stl");
% platemesh = stlread("Q_plaat_1.stl"); 

function [distance_tibiaplateau_plate] = parameter_distance_plateau_to_plate(botmesh, platemesh)

row_top_plate = find((platemesh.Points(:,3)) == max(platemesh.Points(:,3)));
top_plate = platemesh.Points(row_top_plate,:);

[C_list_grens, Points_grens] = freeBoundary(botmesh);
Points_bot = botmesh.Points;

range_top_z = 5;
max_z_bot_index = find(Points_bot(:, 3) == max(Points_bot(:, 3)));
max_z_top_range = Points_bot(max_z_bot_index, 3) - range_top_z;

bot_top_index = find(Points_grens(:, 3) > max_z_top_range);

N = 100;
XYZ_1 = Points_grens(bot_top_index, :);
[n_1,~,p_1] = affine_fit(XYZ_1);

X_projection = top_plate(:,1);
Y_projection = top_plate(:,2);

Z_plane_tibia_plateau = -(n_1(1)/n_1(3)*X_projection+n_1(2)/n_1(3)*Y_projection-dot(n_1,p_1)/n_1(3));

distance_tibiaplateau_plate = vecnorm([top_plate(:,1),top_plate(:,2),top_plate(:,3)] - [X_projection,Y_projection,Z_plane_tibia_plateau]);

% figure
% hold on 
% kleur(tibia_surg_wind, plate,[])
% plot3(top_plate(:,1),top_plate(:,2),top_plate(:,3),'r.', MarkerSize=10)
% plot3(X_projection,Y_projection,Z_plane_tibia_plateau,'r.', MarkerSize=10)
% %plot3(top_bone(:,1),top_bone(:,2),top_bone(:,3),'b.', MarkerSize=10)
% %plot3([top_plate(:,1) top_bone(:,1)],[top_plate(:,2) top_bone(:,2)],[top_plate(:,3) top_bone(:,3)]);
% axis equal
% hold off 

end 