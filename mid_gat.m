% functie voor berekenen midden plaat punt midden schroefgat kop plaat


function [plaat_gat_mid] = mid_gat(plaatmesh)

Points_plaat = plaatmesh.Points;

x_mid = [Points_plaat(224, 1), Points_plaat(513, 1), Points_plaat(551, 1), Points_plaat(799, 1)];
y_mid = [Points_plaat(224, 2), Points_plaat(513, 2), Points_plaat(551, 2), Points_plaat(799, 2)];
z_mid = [Points_plaat(224, 3), Points_plaat(513, 3), Points_plaat(551, 3), Points_plaat(799, 3)]; 

%plot3(x_mid, y_mid, z_mid, 'r.', 'MarkerSize', 20, 'LineStyle', 'none')

gem_x_mid = mean(x_mid);
gem_y_mid = mean(y_mid);
gem_z_mid = mean(z_mid);

plaat_gat_mid = [gem_x_mid, gem_y_mid, gem_z_mid];

% hold on 
% trimesh(plaatmesh)
% plot3(gem_x_mid, gem_y_mid, gem_z_mid, 'k.', 'MarkerSize', 20)
% axis equal

end