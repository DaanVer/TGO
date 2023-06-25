%% Functie die een mesh spiegelt

% INPUT: mesh die wilt spiegelen

% OUTPUT: gespiegelde mesh in het yz vlak 

function [mesh_spiegel] = spiegelen(mesh)

Points_mesh = mesh.Points;
C_list_mesh = mesh.ConnectivityList;

Points_mesh_spiegel = Points_mesh;
Points_mesh_spiegel(:, 1) = -Points_mesh_spiegel(:, 1);

mesh_spiegel = triangulation(C_list_mesh, Points_mesh_spiegel(:, 1), Points_mesh_spiegel(:, 2), Points_mesh_spiegel(:, 3));

end