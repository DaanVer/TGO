function [afstand, bot_top, plaat_top, plaat_top_index] = afstandplateau(botmesh,plaatmesh)

Points_bot = botmesh.Points;
C_list_bot = botmesh.ConnectivityList;

Points_plaat = plaatmesh.Points;
C_list_plaat = plaatmesh.ConnectivityList;

% hold on
bot_top = max(Points_bot(:,3));
plaat_top = max(Points_plaat(:,3));
bot_top_index = find(Points_bot(:,3) == bot_top);
plaat_top_index = find(Points_plaat(:,3) == plaat_top);

% hold on 
% % kleur(botmesh, plaatmesh, [])
% plot3(Points_bot(bot_top_index,1), Points_bot(bot_top_index,2), Points_bot(bot_top_index, 3), 'r.', 'MarkerSize', 20);
% plot3(Points_plaat(plaat_top_index,1),Points_plaat(plaat_top_index,2),Points_plaat(plaat_top_index, 3), 'b.', 'MarkerSize', 20);

afstand = bot_top - plaat_top;

end