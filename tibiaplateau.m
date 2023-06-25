%% Functie voor het bepalen van de range onder het tibiaplateau 

% INPUT: botmesh = een botmesh als stl.file waarin de bovenkant van de mesh
% gelijk is aan de rand van het tibiaplateau 
% mm_onder_tp = hoeveel mm onder het hoogste punt van de mesh wil
% range_onder_vijf = hoeveel mm onder het 'mm_onder_tp'
% range_top_z = hoeveel punten je als rand van het tibiaplateau ziet en een
% vlak doorheen plot
% fractie = vanaf hoeveelste deel van de totale botlengte moeten we
% daarboven kijken voor de range waarin de kop van de plaat kan liggen
% plot = 'yes' or 'nop' 

% OUTPUT: punten_range = de range aan punten van de botmesh 

function [punten_range, punten_range_index, X, Y, Z, n_1, p_1] = tibiaplateau(botmesh, mm_onder_tp, range_onder_vijf)

Points_bot = botmesh.Points;
C_list_bot = botmesh.ConnectivityList;

%Voor nu als standaard nemen?
%mm_onder_tp = 5mm
%range_onder_vijf = 5mm 
range_top_z = 5;
fractie = 5;

[C_list_grens, Points_grens] = freeBoundary(botmesh);

%zonder vervelende driehoek
% driehoekje_weg_index = 9:11;
% Points_grens(driehoekje_weg_index, :) = []; %vervelende driehoekje weghalen 

max_z_bot_index = find(Points_bot(:, 3) == max(Points_bot(:, 3)));
max_z_top_range = Points_bot(max_z_bot_index, 3) - range_top_z;

bot_top_index = find(Points_grens(:, 3) > max_z_top_range);

formule = abs(max(Points_bot(:, 3)) - min(Points_bot(:, 3)));
bot_fractie = max(Points_bot(:, 3)) - (formule/fractie);

bot_bvn_fractie_index = find(Points_bot(:, 3) > bot_fractie);

Points_bot_bvn = Points_bot(bot_bvn_fractie_index, :);
bot_bvn_x = Points_bot(bot_bvn_fractie_index, 1);
bot_bvn_y = Points_bot(bot_bvn_fractie_index, 2);
bot_bvn_z = Points_bot(bot_bvn_fractie_index, 3);

%%

N = 100;
XYZ_1 = Points_grens(bot_top_index, :);
[n_1,~,p_1] = affine_fit(XYZ_1);

X_1 = Points_grens(bot_top_index(1), 1);
X_end = Points_grens(bot_top_index(end), 1);
Y_1 = Points_grens(bot_top_index(1), 2);
Y_end = Points_grens(bot_top_index(end), 2);

x = linspace(X_1 - 50, X_end + 50, N);
y = linspace(Y_1 - 50, Y_end + 50, N);
[X, Y] = meshgrid(x, y);

Z = -(n_1(1)/n_1(3)*X+n_1(2)/n_1(3)*Y-dot(n_1,p_1)/n_1(3));
Z_vijf = Z - mm_onder_tp;
Z_range_onder_vijf = Z_vijf - range_onder_vijf;

Z_bvn_vijf = -(n_1(1)/n_1(3)*bot_bvn_x+n_1(2)/n_1(3)*bot_bvn_y-dot(n_1,p_1)/n_1(3)) - mm_onder_tp;
Z_bvn_range_onder_vijf = -(n_1(1)/n_1(3)*bot_bvn_x+n_1(2)/n_1(3)*bot_bvn_y-dot(n_1,p_1)/n_1(3)) - mm_onder_tp - range_onder_vijf;

bot_range_vlakken_index = find(bot_bvn_z < Z_bvn_vijf & bot_bvn_z > Z_bvn_range_onder_vijf);

punten_range_bvn = [Points_bot_bvn(bot_range_vlakken_index, 1), Points_bot_bvn(bot_range_vlakken_index, 2), Points_bot_bvn(bot_range_vlakken_index, 3)];
punten_range_index = find(ismember(Points_bot, punten_range_bvn, 'rows') == 1);
punten_range = [Points_bot(punten_range_index, 1), Points_bot(punten_range_index, 2), Points_bot(punten_range_index, 3)];

%%
% 
% if plot == 'yes'
    % hold on 
    % trimesh(botmesh, 'FaceAlpha', 0.3, 'EdgeAlpha', 0.3);
    % plot3(Points_bot(max_z_bot_index, 1), Points_bot(max_z_bot_index, 2), Points_bot(max_z_bot_index, 3), 'r.', 'MarkerSize', 20)
    % plot3(Points_grens(:, 1), Points_grens(:, 2), Points_grens(:, 3), 'g.', 'MarkerSize', 5, 'LineStyle', 'none')
    % plot3(Points_grens(bot_top_index, 1), Points_grens(bot_top_index, 2), Points_grens(bot_top_index, 3), 'cyan.', 'MarkerSize', 10, 'LineStyle', 'none')
    % 
    % [aa bb] = meshgrid(-50:0.5:50);     %Creates a meshgrid on the level of the fraction cut-off value
    % cc = zeros(size(aa, 1))+bot_fractie; 
    % surf(aa, bb, cc, 'FaceAlpha', 0.03, 'EdgeAlpha', 0.03) 
    % 
    % surf(X, Y, Z, 'FaceAlpha', 0.08, 'EdgeAlpha', 0.08, 'FaceColor', 'red', 'EdgeColor', 'red');
    % surf(X, Y, Z_vijf, 'FaceAlpha', 0.08, 'EdgeAlpha', 0.08, 'FaceColor', 'green', 'EdgeColor', 'green');
    % surf(X, Y, Z_range_onder_vijf, 'FaceAlpha', 0.08, 'EdgeAlpha', 0.08, 'FaceColor', 'blue', 'EdgeColor', 'blue');
    % 
    % plot3(bot_bvn_x(bot_range_vlakken_index), bot_bvn_y(bot_range_vlakken_index), bot_bvn_z(bot_range_vlakken_index), 'r.', 'MarkerSize', 10, 'LineStyle', 'none')
    % plot3(p_1(1),p_1(2),p_1(3),'ro','markersize',15,'markerfacecolor','red'); %voor punt in vlak 
    % quiver3(p_1(1),p_1(2),p_1(3),n_1(1)/3,n_1(2)/3,n_1(3)/3, 12,'r','linewidth',2) %voor normaalvector vlak
    % 
    % axis equal
    % grid off
    % rotate3d('on')
% % end

% view(-50, 20)
% xlim([-50, 10])
% ylim([-50, 10])
% zlim([-30, 20])

end