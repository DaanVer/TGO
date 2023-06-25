%% Functie botcontact percentage bepalen + range dat buiten botopp valt

% INPUT = botmesh en plaatmesh ingelezen als stl-file + range om
% botoppervlakte waarin punten nog als in het bot gezien mogen worden.
% Kan range als 'TOL' bij inpolyhedron erbij doen, maar werkt niet echt.

% OUTPUT = percentage botcontact volgens de oppervlakten van driehoekjes in mm^2.

function [percentage_botcontact_area_in_range] = botcontact_area_range_v2(botmesh, plaatmesh, range)

Points_bot = botmesh.Points;
C_list_bot = botmesh.ConnectivityList;

Points_plaat = plaatmesh.Points;
C_list_plaat = plaatmesh.ConnectivityList;

%%

punten_binnen = inpolyhedron(C_list_bot, Points_bot, Points_plaat);

Points_plaat_in_x = Points_plaat(punten_binnen, 1);
Points_plaat_in_y = Points_plaat(punten_binnen, 2);
Points_plaat_in_z = Points_plaat(punten_binnen, 3);

Points_plaat_in = [Points_plaat_in_x, Points_plaat_in_y, Points_plaat_in_z];

%% Voor punten in het bot 

[~, Points_index] = ismember(Points_plaat_in, Points_plaat, 'rows');

C_list_index = ismember(C_list_plaat, Points_index);
col_1 = find(C_list_index(:, 1) == 1);
col_2 = find(C_list_index(:, 2) == 1);
col_3 = find(C_list_index(:, 3) == 1);

col_123 = vertcat(col_1, col_2, col_3);
C_list_index = unique(col_123);

%C_list_plaat_in = C_list_plaat(C_list_index, :);

%% Voor punten in de range 

[~, ~, mindistance] = find_shortest_distance(plaatmesh, botmesh);

range_index = find(mindistance < range);
%punten_plaat_in_range = Points_plaat(range_index, :);

C_list_range_index = ismember(C_list_plaat, range_index);
col_1 = find(C_list_range_index(:, 1) == 1);
col_2 = find(C_list_range_index(:, 2) == 1);
col_3 = find(C_list_range_index(:, 3) == 1);

col_123 = vertcat(col_1, col_2, col_3);
C_list_range_index = unique(col_123);

%%

area_in = 0;
area_range = 0;
area_plaat = 0;

for i_in = 1:length(C_list_index)
    a_in = Points_plaat(C_list_plaat(C_list_index(i_in, :), :), :);
    p1_in = a_in(1, :);
    p2_in = a_in(2, :);
    p3_in = a_in(3, :);
    p1_2_in = p2_in - p1_in;
    p1_3_in = p3_in - p1_in;
    kruis_in = cross(p1_2_in, p1_3_in);
    grootte_in = norm(kruis_in);
    area_in = area_in + 0.5*grootte_in;
end

for i_range = 1:length(C_list_range_index)
    a_range = Points_plaat(C_list_plaat(C_list_range_index(i_range, :), :), :);
    p1_range = a_range(1, :);
    p2_range = a_range(2, :);
    p3_range = a_range(3, :);
    p1_2_range = p2_range - p1_range;
    p1_3_range = p3_range - p1_range;
    kruis_range = cross(p1_2_range, p1_3_range);
    grootte_range = norm(kruis_range);
    area_range = area_range + 0.5*grootte_range;
end

for i_plaat = 1:length(C_list_plaat)
    a_plaat = Points_plaat(C_list_plaat(i_plaat, :), :);
    p1_plaat = a_plaat(1, :);
    p2_plaat = a_plaat(2, :);
    p3_plaat = a_plaat(3, :);
    p1_2_plaat = p2_plaat - p1_plaat;
    p1_3_plaat = p3_plaat - p1_plaat;
    kruis_plaat = cross(p1_2_plaat, p1_3_plaat);
    grootte_plaat = norm(kruis_plaat);
    area_plaat = area_plaat + 0.5*grootte_plaat;
end

area_in_range = area_in + area_range;

area_in_range = round(area_in_range, 1); %mm^2
area_plaat = round(area_plaat, 1); %mm^2

percentage_botcontact_area_in_range = (area_in_range/area_plaat)*100;
percentage_botcontact_area_in_range = round(percentage_botcontact_area_in_range, 1);

end