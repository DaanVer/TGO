%% Functie voor klikken om wedge te segmenteren + interpoleren 


function [Points_wedge, P_wedge] = click4wedge_segmenteren(botmesh)

Points_bot = botmesh.Points;

Points_bot_index_matrix = clickA3DPoint(botmesh);

Points_wedge = [Points_bot(Points_bot_index_matrix(1), :); Points_bot(Points_bot_index_matrix(2), :); Points_bot(Points_bot_index_matrix(3), :)];

%%

[F, P] = freeBoundary(botmesh);

[~, Points_wedge_max_z_index] = max(Points_wedge(:, 3));
[~, Points_wedge_min_z_index] = min(Points_wedge(:, 3));
[~, Points_wedge_in_snede_index] = min(Points_wedge(:, 2));
[~, Points_wedge_lat_index] = max(Points_wedge(:, 2));

Points_wedge_max_z = Points_wedge(Points_wedge_max_z_index, :);
Points_wedge_min_z = Points_wedge(Points_wedge_min_z_index, :);
Points_wedge_in_snede = Points_wedge(Points_wedge_in_snede_index, :);
Points_wedge_lat = Points_wedge(Points_wedge_lat_index, :);

%%

P_zndr_ondr = P();
weg_ondr_ondr_wedge_index = find(P(:, 3) < Points_wedge_min_z(:, 3));
P_zndr_ondr(weg_ondr_ondr_wedge_index, :) = [];

P_zndr_ondr_bvn = P_zndr_ondr;
weg_bvn_bvn_wedge_index = find(P_zndr_ondr(:, 3) > Points_wedge_max_z(:, 3));
P_zndr_ondr_bvn(weg_bvn_bvn_wedge_index, :) =[];

P_zndr_ondr_bvn_med = P_zndr_ondr_bvn;
weg_med_in_wedge_index = find(P_zndr_ondr_bvn(:, 1) > Points_wedge_in_snede(:, 1) & P_zndr_ondr_bvn(:, 2) < Points_wedge_in_snede(:, 2));
P_zndr_ondr_bvn_med(weg_med_in_wedge_index , :) =[];

P_zndr_ondr_bvn_med_lat = P_zndr_ondr_bvn_med;
weg_lat_wedge_index = find(P_zndr_ondr_bvn_med(:, 2) > Points_wedge_lat(:, 2));
P_zndr_ondr_bvn_med_lat(weg_lat_wedge_index, :) =[];

%%

P_wedge = P_zndr_ondr_bvn_med_lat;

interp_aantal = 1000;

P_wedge_top_interp = interparc(interp_aantal, P_wedge(:, 1), P_wedge(:, 2), P_wedge(:, 3)); 

hold on 
trimesh(botmesh, 'FaceAlpha', 0.3, 'EdgeAlpha', 0.3)
plot3(P_wedge(:, 1), P_wedge(:, 2), P_wedge(:, 3), 'r.', 'MarkerSize', 10)
plot3(P_wedge_top_interp(:, 1), P_wedge_top_interp(:, 2), P_wedge_top_interp(:, 3), 'g.', 'MarkerSize', 5);
axis equal 
rotate3d('on')

end







