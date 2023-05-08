pat1postop = stlread("TGO-stl\Patiënt 1\Pat1Tibiapostop.stl");
pat2postop = stlread("TGO-stl\Patiënt 2\Pat2Tibiapostop.stl");
plate = stlread("TGO-stl\Tibia TomoFix plaat (in-house scanned)\HTO tomofix plate.stl");

%%
trimesh(pat1postop);
%trimesh(pat1fem);
axis equal

%%
trimesh(pat2postop);
axis equal

%%
trimesh(plate);
axis equal

%%
[intersect12, Surf12] = SurfaceIntersection(pat1postop, plate);
%%
clf; hold on
S=Surf12; trisurf(S.faces, S.vertices(:,1),S.vertices(:,2),S.vertices(:,3),'EdgeColor', 'r', 'FaceColor', 'r');
trimesh(plate);
trimesh(pat1postop);
title ('Surface/Surface intersections')
legend({'#1/#2'});
view([3 1 1])
axis equal