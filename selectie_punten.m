%% Script voor het aantal punten in de botrange die je wilt gebruiken 

% INPUT = aantal_punten = 'getal'

% OUTPUT = het aantal punten ingevuld in de botrange beschreven door bot_range_x, y en z.

%aantal_punten = 100;

function [selectie_punten] = selectie_punten(aantal_punten,h)
rijen = round(linspace(1, length(h), aantal_punten));
selectie_punten = h(rijen,:);
end