%% Functie voor het bepalen van de hoek tussen het schuine tibiaplateau en de plaat


function [hoek_tibiaplateau_plaat] = hoek_tp_plaat(botmesh, plaatmesh, mm_onder_tp, range_onder_vijf)

Points_bot = botmesh.Points;
Points_plaat = plaatmesh.Points;

[punten_range, punten_range_index, X, Y, Z, n_1, p_1] = tibiaplateau(botmesh, mm_onder_tp, range_onder_vijf);
[afstand, bot_top, plaat_top, plaat_top_index] = afstandplateau(botmesh, plaatmesh);

plaat_top_punten = [Points_plaat(plaat_top_index, 1), Points_plaat(plaat_top_index, 2), Points_plaat(plaat_top_index, 3)];

%%

p1_plaat = [Points_plaat(3277, 1), Points_plaat(3277, 2), Points_plaat(3277, 3)];
p2_plaat = [Points_plaat(3, 1), Points_plaat(3, 2), Points_plaat(3, 3)];

vector_p12_plaat = p2_plaat - p1_plaat;

X_punten = [p1_plaat(1); p2_plaat(1)];
Y_punten = [p1_plaat(2); p2_plaat(2)];
Z_punten = -(n_1(1)/n_1(3)*X_punten+n_1(2)/n_1(3)*Y_punten-dot(n_1,p_1)/n_1(3));

p1_vlak = [X_punten(1), Y_punten(1), Z_punten(1)];
p2_vlak = [X_punten(2), Y_punten(2), Z_punten(2)];

vector_p12_vlak = p2_vlak - p1_vlak;

hoek_tibiaplateau_plaat = abs(acos(dot(vector_p12_vlak, vector_p12_plaat)/norm(vector_p12_vlak)/norm(vector_p12_plaat)));
hoek_tibiaplateau_plaat = rad2deg(hoek_tibiaplateau_plaat);

%%

% hold on 
% kleur(botmesh, [], []);
% trimesh(plaatmesh, 'FaceAlpha', 0.3, 'EdgeAlpha', 0.3, 'FaceColor', 'red', 'EdgeColor', 'green')
% 
% surf(X, Y, Z, 'FaceAlpha', 0.08, 'EdgeAlpha', 0.08, 'FaceColor', 'red', 'EdgeColor', 'red');
% surf(X, Y, Z-afstand, 'FaceAlpha', 0.08, 'EdgeAlpha', 0.08, 'FaceColor', 'red', 'EdgeColor', 'red');
% 
% plot3(Points_plaat(plaat_top_index, 1), Points_plaat(plaat_top_index, 2), Points_plaat(plaat_top_index, 3), 'k.', 'MarkerSize', 20) 
% %plot3(X_punten, Y_punten, Z_punten-afstand, 'b.', 'MarkerSize', 20, 'LineStyle', 'none')
% %plot3(p1_vlak(1), p1_vlak(2), p1_vlak(3)-afstand, 'b.', 'MarkerSize', 20)
% %plot3(p2_vlak(1), p2_vlak(2), p2_vlak(3)-afstand, 'b.', 'MarkerSize', 20)
% 
% %quiver3(plaat_top_punten(:, 1), plaat_top_punten(:, 2), plaat_top_punten(:, 3), n_1(1), n_1(2), n_1(3), 10, 'k')
% quiver3(plaat_top_punten(:, 1), plaat_top_punten(:, 2), plaat_top_punten(:, 3), vector_p12_plaat(1), vector_p12_plaat(2), vector_p12_plaat(3), 10, 'k', 'LineWidth', 2)
% quiver3(plaat_top_punten(:, 1), plaat_top_punten(:, 2), plaat_top_punten(:, 3), vector_p12_vlak(1), vector_p12_vlak(2), vector_p12_vlak(3), 10, 'k', 'LineWidth', 2)
% 
% %hoek_txt = sprintf('\x03B8 = %.1f°', hoek_tibiaplateau_plaat);
% %text(plaat_top_punten(:, 1)-30, plaat_top_punten(:, 2)+20, plaat_top_punten(:, 3)-1, hoek_txt, 'FontSize', 12);
% 
% axis equal
% rotate3d('on')
% 
% view(-42.2644,7.2268)
% xlim([-44.916, -2.0467])
% ylim([-46.6179, -11.9015])
% zlim([-55.8301, 6.4944])

%end











