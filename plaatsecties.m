
%% functie 
function [rijen_onderkant, rijen_links_boven, rijen_rechts_boven] = plaatsecties(plate)
% input: punten van de plaat 
% output: rijen van de punten van de onderkant en links en rechts boven 

%% 
P_x = plate.Points(:,1);
P_y = plate.Points(:,2);
P_z = plate.Points(:,3);

%% onderkant plaat 
onderkant = P_z < -90 & P_y > -50; 

% onderkant_plaat = plate.Points.*onderkant;
% 
% remove = find(onderkant_plaat(:,1) == 0);
% onderkant_plaat(remove,:) = [];

%% bovenkant 
% bovenkant = P_z > -10;

% bovenkant_plaat = plate.Points.*bovenkant;
% 
% remove1 = find(bovenkant_plaat(:,1) == 0);
% bovenkant_plaat(remove1,:) = [];

%% links boven 
links = P_x < -13 & P_y > -46; 

% links_boven = plate.Points.*links; 
% 
% remove2 = find(links_boven(:,1) == 0);
% links_boven(remove2,:) = [];

%% rechts boven 
rechts = P_x > 5 & P_y > -47;

% rechts_boven = plate.Points.*rechts;
% 
% remove3 = find(rechts_boven(:,1) == 0);
% rechts_boven(remove3,:) = [];

%% 
rijen_onderkant = find((onderkant) == 1);
rijen_rechts_boven = find((rechts) == 1);
rijen_links_boven = find((links) == 1);

end 
