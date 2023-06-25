%% Function voor het afbakenen van de range op het bot waarin de eerste contactpunten van de plaat kunnen komen

% INPUT: botmesh en plaatmesh = stl.files ingeladen met stlread.
                
% OUTPUT: dingen

function [botrange_punten,punten_range] = botrange(botmesh, mm_onder_tp, range_onder_vijf, verhouding,marge)

Points_bot = botmesh.Points;

punten_range = tibiaplateau(botmesh, mm_onder_tp, range_onder_vijf);

%%

bot_max_z = max(Points_bot(:,3));
bot_min_z= min(Points_bot(:,3));
lengte_bot = abs(bot_max_z - bot_min_z);

fractie_tuber = 0.3;
range_tuber = 0.5;

tuber_z = lengte_bot * -fractie_tuber;
tuber_index = find((Points_bot(:, 3) > (tuber_z - range_tuber)) & (Points_bot(:, 3) < (tuber_z + range_tuber)));
tuber_selectie = Points_bot(tuber_index, :);
tuber_max_x_index = find(tuber_selectie(:, 1) == max(tuber_selectie(:, 1)));
tuber = tuber_selectie(tuber_max_x_index, :);

%%

fractie_cndyl = 0.05;
range_cndyl = 2;

cndyl_z = lengte_bot * -fractie_cndyl;
cndyl_index = find((Points_bot(:, 3) > (cndyl_z - range_cndyl)) & (Points_bot(:, 3) < (cndyl_z + range_cndyl)));
cndyl_selectie = Points_bot(cndyl_index, :);
cndyl_max_y_index = find(cndyl_selectie(:, 2) == max(cndyl_selectie(:, 2)));
cndyl = cndyl_selectie(cndyl_max_y_index, :);

dist_XY_cndyl_tuber = sqrt((tuber(:, 1) - cndyl(:, 1))^2 + (tuber(:, 2) - cndyl(:, 2))^2);

%%

verhouding_cndyl = verhouding;
verhouding_tuber = 100 - verhouding;

%%

dist_cndyl_mid = dist_XY_cndyl_tuber - dist_XY_cndyl_tuber*verhouding_tuber/100;
dist_tuber_mid = dist_XY_cndyl_tuber - dist_XY_cndyl_tuber*verhouding_cndyl/100;

dist_mid_rechts_gat = 11.38;
range = dist_XY_cndyl_tuber * (marge/100);

dist_cndyl_rechts = dist_cndyl_mid + dist_mid_rechts_gat;
dist_tuber_rechts = dist_tuber_mid - dist_mid_rechts_gat;

dist_cndyl_recht_range = dist_cndyl_rechts - range;
dist_tuber_rechts_range = dist_tuber_rechts - range;

%% Nu worden cirkels nog op hoogte van de condyle gezet, maar moet niet gem tibiaplateau range???

Points_bot = punten_range;

%Pythagoras gebruiken 
piet_cndyl = sqrt((Points_bot(:, 1) - cndyl(:, 1)).^2 + (Points_bot(:, 2) - cndyl(:, 2)).^2); 
piet_tuber = sqrt((Points_bot(:, 1) - tuber(:, 1)).^2 + (Points_bot(:, 2) - tuber(:, 2)).^2); 

piet_cndyl_index = find(piet_cndyl > dist_cndyl_recht_range);
piet_tuber_index = find(piet_tuber > dist_tuber_rechts_range);

cndyl_tuber_range_index = find(ismember(Points_bot(piet_cndyl_index), Points_bot(piet_tuber_index)));

botrange_punten = [Points_bot(piet_cndyl_index(cndyl_tuber_range_index), 1), Points_bot(piet_cndyl_index(cndyl_tuber_range_index), 2), Points_bot(piet_cndyl_index(cndyl_tuber_range_index), 3)];

end