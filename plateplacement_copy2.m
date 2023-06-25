function [placedplate_mesh] = plateplacement_copy2(tib_postop,surgicalwindow,plate,ratio,angle_min,angle_max,margin,dist_min,dist_max,plate_bone_dist,max_in_bone)

%% Alle te testen bot punten vinden

% Nodig:
% L_or_R;

clear allpossiblepositions
clear allpossiblepositions2

% tib_postop = stlread("TGO-stl\Patiënt 1\Pat1Tibiapostop_bovenkant.stl");
% surgicalwindow = stlread("TGO-stl\Patiënt 1\Pat1Tibiapostop_SW_nieuw.stl");
% plate = stlread("TGO-stl\Tibia TomoFix plaat (in-house scanned)\HTO tomofix plate_AL.stl");
% angle_min = 3;
% angle_max = 8;
% dist_min = 5;
% dist_max = 10;
% ratio = 45;
% margin = 3;
% plate_bone_dist = 0.2;

wait = waitbar(0,'Please wait...');
pause(1)

dist_max_adjusted = dist_max + 13;

[all_points,puntenrange] = botrange(surgicalwindow,dist_min,(dist_max_adjusted - dist_min),ratio,margin);
test = round(0.10 * length(all_points)); % Aantal te testen punten op het bot
bo_testpoints = selectie_punten(test,all_points);

%% Middelpunt cirkel door surgical window

x_cirkelf = puntenrange(:,1);
y_cirkelf = puntenrange(:,2);

[xo, yo, ~] = circle_fit(x_cirkelf,y_cirkelf);
mp = [xo,yo];

%% Te testen plaatpunten vinden
load("punten_voor_assen.mat","punten_voor_assen");

%% Vinden van zijkanten en onderkant plaat

[onderkant,li_boven, ~ ] = plaatsecties(plate);

%% Plaat naar 1e, 2e en 3e punt laten bewegen
faces_tib = tib_postop.ConnectivityList;
vertices_tib = tib_postop.Points;

allpossiblepositions = struct(); % Initialize structure for results


% N = angle_max - angle_min; % Aantal te testen hoeken in for loop hieronder
% ang = angle_min; % Vanaf welke hoek moet er berekend worden?
counter1 = 1/16;
for n = 1:length(punten_voor_assen(:,1))
    p1 = punten_voor_assen(n,1); % Plaat contactpunten
    %p2 = punten_voor_assen(n,2); % Spiegeling op de achterkant van de plaat van de punten hierboven
    p3 = punten_voor_assen(n,2); % Punten onder de plaatcontactpunten om plaat in eigen z-as te kunnen draaien

    pp = plate.Points(p1,:); % Punt op de plaat die het bot moet raken
    bonecontact = struct();

    waitbar(counter1,wait,'Determining plate positions...')
    pause(1)
    counter1 = counter1 + (1/16);


    parfor i = 1:length(bo_testpoints) % Alle mogelijke posities testen
        [plateT]=Translate(plate,bo_testpoints(i,:),pp,"xyz");
        a = rotate_p(mp,plateT.Points(p1,:));
        plateT = Rotate(plateT,plateT.Points(p1,:),a,"z");
        angle_results = struct(); % Initialize structure for angle results

        for j = angle_min:2:angle_max % Alle mogelijke rotaties van de plaat
            m = j - angle_min + 1;

            point1 = plateT.Points(p1,:);
            % point2 = plateT.Points(p2,:);
            point2_2 = [mp(1,1),mp(1,2),point1(1,3)];
            point3 = plateT.Points(p3,:);

            plateR = rotate_custom_axis(plateT,point1,point2_2,j);

            if point1(1,3) < point3(1,3) % Make sure the z-axis runs from proximal to distal on the plate (otherwise the plate will rotate away from the bone)
                point1 = plateT.Points(p3,:);
                point3 = plateT.Points(p1,:);
            end

            shortest_distance = find_shortest_distance_points(plateR.Points(li_boven,:),surgicalwindow);
            x = shortest_distance * 0.7;
            plateR = rotate_custom_axis(plateR,point1,point3,x);

            step1 = 0.15;
            step2 = 0.05;
            k = 0;
            l = 0;
            shortest_d = 10;
            shortest_d2 = 10;
            counter = 0;
            while shortest_d > 0.15
                if k > 30
                    break
                end
                point1 = plateT.Points(p1,:);
                point2 = plateT.Points(p3,:);

                if point1(1,3) < point2(1,3) % Make sure the z-axis runs from proximal to distal on the plate (otherwise the plate will rotate away from the bone)
                    point1 = plateT.Points(p3,:);
                    point2 = plateT.Points(p1,:);
                end

                plateRR = rotate_custom_axis(plateR,point1,point2,-k);

               if counter == 0
                    distance = parameter_distance_plateau_to_plate(surgicalwindow,plateT);
                    if distance > dist_max || distance < dist_min
                        angle_results(m).plate = 'height';
                        break
                    end
                    counter = 1;
                end

                % Stop bij 2e contactpunt
                QPTS = plateRR.Points(li_boven,:);

                [shortest_d,pt2,~] = find_shortest_distance_points2(QPTS,surgicalwindow);


                k = k + step1;

            end

            counter = 0;
            % Rotate around the first two contactpoints
            while shortest_d2 > 0.15
                % Check if a point was found above
                if k > 30
                    angle_results(m).plate = 'limit';
                    break
                elseif distance > dist_max || distance < dist_min
                    break
                elseif counter == 0
                    point1 = plateT.Points(p1,:);
                    point2 = pt2;

                    shortest_distance = find_shortest_distance_points(plateRR.Points(onderkant,:),surgicalwindow);
                    x = shortest_distance * 0.7;
                    plateRR = rotate_custom_axis(plateRR,point1,point2,x);

                    counter = 1;
                end

                if l > 20
                    break
                end


                plateRRR = rotate_custom_axis(plateRR,point1,point2,l);
                % Stop bij 3e contactpunt

                QPTS = plateRRR.Points(onderkant,:);

                [shortest_d2,~,~] = find_shortest_distance_points2(QPTS,surgicalwindow);


                l = l + step2;

                angle_results(m).plate.Points = plateRRR.Points;
                angle_results(m).plate.ConnectivityList = plateRRR.ConnectivityList;
            end
        end
        bonecontact(i).angle_results = angle_results;
    end
    allpossiblepositions.platecontactpoint(n).bonecontact = bonecontact;
end

waitbar(counter1,wait,'Determining optimal position...')
pause(1)


%% Uit totaal aantal mogelijke posities de daadwerkelijk mogelijke posities bepalen

% Niet meer dan 0... mm in het bot
% Programmeren met inpolyhedron en kortste afstand

allpossiblepositions2 = allpossiblepositions;
for j = 1:8
    for k = 1:test
        for l = 1:(angle_max - angle_min + 1)
            platepos = allpossiblepositions2.platecontactpoint(j).bonecontact(k).angle_results(l).plate;

            if ~isa(platepos,"struct")%isempty(platepos)
                %disp('break in bot');
                break
            end
            %disp('geen break in bot');

            points = platepos.Points;
            [IN] = inpolyhedron(faces_tib,vertices_tib,points);

            IN = find(IN);
            clear test_points
            test_points = zeros(length(IN),3);
            for x = 1:length(IN)
                test_points(x,:) = points(IN(x,1),:);
            end

            [longest_shortest_distance, ~] = find_longest_shortest_distance(test_points,surgicalwindow);

            if longest_shortest_distance >= max_in_bone
                allpossiblepositions2.platecontactpoint(j).bonecontact(k).angle_results(l).plate = [];
                %disp('weggegooid')
            end
        end
    end
end

% Minimale en maximale afstand onder tibia plateau checken

for j = 1:8
    for k = 1:test
        for l = 1:(angle_max - angle_min + 1)
            platepos = allpossiblepositions2.platecontactpoint(j).bonecontact(k).angle_results(l).plate;

            if ~isa(platepos,"struct")%isempty(platepos)
                %disp('break min max');
                break
            end
            %disp('geen break min max');

            distance = parameter_distance_plateau_to_plate(surgicalwindow,platepos);

            if distance > dist_max || distance < dist_min
                allpossiblepositions2.platecontactpoint(j).bonecontact(k).angle_results(l).plate = [];
                %disp('weggegooid')
            end

        end
    end
end

%% Optimale plaatpositie bepalen

% Schroefgaten tenopzichte van de wig

% Richting van schroefgaten, goede plaatsing in bot

% Percentage botcontact (zo laag mogelijk)
placedplate = [];
bonecontact_p_small = 100;
for j = 1:8
    for k = 1:test
        for l = 1:(angle_max - angle_min + 1)
            platepos = allpossiblepositions2.platecontactpoint(j).bonecontact(k).angle_results(l).plate;

            if ~isa(platepos,"struct")%isempty(platepos)
                %disp('break bonecontact small');
                break
            end
            %disp('geen break bonecontact small');

            bonecontact_p = botcontact_area_range_v2(tib_postop,platepos,plate_bone_dist);

            if bonecontact_p_small < bonecontact_p
                allpossiblepositions2.platecontactpoint(j).bonecontact(k).angle_results(l).plate = [];
            else
                bonecontact_p_small = bonecontact_p;
                placedplate = platepos;
            end

        end
    end
end

if ~isempty(placedplate)
    placedplate_mesh = triangulation(placedplate.ConnectivityList,placedplate.Points);
else
    placedplate_mesh = [];
end

waitbar(1,wait,'Finishing...')
pause(1)

% points = placedplate_mesh.Points;
%             [IN] = inpolyhedron(faces_tib,vertices_tib,points);
% 
%             IN = find(IN);
%             clear test_points
%             test_points = zeros(length(IN),3);
%             for x = 1:length(IN)
%                 test_points(x,:) = points(IN(x,1),:);
%             end
% 
%             [longest_shortest_distance, ~] = find_longest_shortest_distance(test_points,surgicalwindow)

% Points = allpossiblepositions.platecontactpoint(4).bonecontact(7).angle_results(1).plate.Points;
% ConnectivityList = allpossiblepositions.platecontactpoint(4).bonecontact(7).angle_results(1).plate.ConnectivityList;
% 
% placedplate_mesh = triangulation(ConnectivityList,Points);

% hold on
% trimesh(placedplate_mesh)
% trimesh(tib_postop)
% axis equal

% kleur_transparant(tib_postop,placedplate_mesh,stlread("TGO-stl\Patiënt 1\Q_plaat_1.stl"));


end