%% Functie die op basis van het wedge segement de afstand wedge-schroefgat berekend


function [min_z_bvn2wedge, min_z_ondr2wedge] = dist_gat2wedge(wedgesegment, plaatmesh)

P_wedge = wedgesegment;

Points_plaat = plaatmesh.Points;

schroefgat_bvn = Points_plaat(3276, :);
schroefgat_ondr = Points_plaat(1680, :);

% hold on 
% trimesh(plaatmesh, 'FaceAlpha', 0.3, 'EdgeAlpha', 0.3, 'FaceColor', 'red', 'EdgeColor', 'green')
% plot3(schroefgat_bvn(:, 1), schroefgat_bvn(:, 2), schroefgat_bvn(:, 3), 'k.', 'MarkerSize', 20, 'LineStyle', 'none')
% plot3(schroefgat_ondr(:, 1), schroefgat_ondr(:, 2), schroefgat_ondr(:, 3), 'k.', 'MarkerSize', 20, 'LineStyle', 'none' )
% axis equal
% rotate3d('on')

%%

dist_bvn2wedge = pdist2(schroefgat_bvn, P_wedge);
min_bvn2wedge_index = find(dist_bvn2wedge == min(dist_bvn2wedge));
min_bvn2wedge = min(dist_bvn2wedge);

dist_ondr2wedge = pdist2(schroefgat_ondr, P_wedge);
min_ondr2wedge_index = find(dist_ondr2wedge == min(dist_ondr2wedge));
min_ondr2wedge = min(dist_ondr2wedge);

min_z_bvn2wedge = abs(schroefgat_bvn(:, 3) - (P_wedge(min_bvn2wedge_index, 3)));
min_z_ondr2wedge = abs(schroefgat_ondr(:, 3) - (P_wedge(min_ondr2wedge_index, 3)));

% plot3(P_wedge(min_bvn2wedge_index, 1), P_wedge(min_bvn2wedge_index, 2), P_wedge(min_bvn2wedge_index, 3), 'k.', 'MarkerSize', 20)
% plot3(P_wedge(min_ondr2wedge_index, 1), P_wedge(min_ondr2wedge_index, 2), P_wedge(min_ondr2wedge_index, 3), 'k.', 'MarkerSize', 20)
% 
% plot3([P_wedge(min_bvn2wedge_index, 1), schroefgat_bvn(:, 1)], [P_wedge(min_bvn2wedge_index, 2), schroefgat_bvn(:, 2)], [P_wedge(min_bvn2wedge_index, 3), schroefgat_bvn(:, 3)], 'LineWidth', 3)
% plot3([P_wedge(min_ondr2wedge_index, 1), schroefgat_ondr(:, 1)], [P_wedge(min_ondr2wedge_index, 2), schroefgat_ondr(:, 2)], [P_wedge(min_ondr2wedge_index, 3), schroefgat_ondr(:, 3)], 'LineWidth', 3)

end



