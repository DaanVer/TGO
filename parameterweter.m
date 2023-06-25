%% Functie voor alle parameters bepalen voor een plaatpositie


function [afstand, distance_plate_condyle, distance_plate_tuberositas, verhouding_condyle_mid, verhouding_tuber_mid, max_afstand_plaat_in_bot, percentage_botcontact_area_in_range, min_z_bvn2wedge, min_z_ondr2wedge, hoek_tibiaplateau_plaat] = parameterweter(botmesh, plaatmesh, tibia, P_wedge, range, mm_onder_tp, range_onder_vijf)

% range = 0.2;
% mm_onder_tp = 5;
% range_onder_vijf = 5;

[plaat_gat_mid] = mid_gat(plaatmesh);

%[Points_wedge, P_wedge] = click4wedge_segmenteren(botmesh);

[min_z_bvn2wedge, min_z_ondr2wedge] = dist_gat2wedge(P_wedge, plaatmesh);

[afstand, ~, ~] = afstandplateau(botmesh,plaatmesh);

[distance_plate_tuberositas, distance_plate_condyle, tuberositas, condyle] = parameter_tuber_condyle_to_plate(plaatmesh, botmesh);

afstand_mid_condyle = sqrt((plaat_gat_mid(:, 1) - condyle(:, 1))^2 + (plaat_gat_mid(:, 2) - condyle(:, 2))^2);
afstand_condyle_tuber = sqrt((plaat_gat_mid(:, 1) - tuberositas(:, 1))^2 + (plaat_gat_mid(:, 2) - tuberositas(:, 2))^2);
afstand_condyle_via_mid_tuber = afstand_mid_condyle + afstand_condyle_tuber;

verhouding_condyle_mid = (afstand_mid_condyle/afstand_condyle_via_mid_tuber) * 100;
verhouding_tuber_mid = (afstand_condyle_tuber/afstand_condyle_via_mid_tuber) * 100;

[max_afstand_plaat_in_bot] = parameter_maxafstand_in_bot(plaatmesh, tibia, botmesh);

[percentage_botcontact_area_in_range] = botcontact_area_range(botmesh, plaatmesh, range);

[hoek_tibiaplateau_plaat] = hoek_tp_plaat(botmesh, plaatmesh, mm_onder_tp, range_onder_vijf);

end