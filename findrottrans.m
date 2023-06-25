%This function finds and gives the rotation matrix and translation vector.
%INPUT: mesh (being the original mesh) and rottransmesh (being the rotated 
%and translated mesh). 
%OUTPUT: rotationmatrix (3x3 double matrix) and translationvector (1x3
%double vector). 

function [rotationmatrix,translationvector] = findrottrans(mesh,rottransmesh)

%Calculate the center of both meshes.
centerofmesh = mean(mesh.Points, 1);
centerofrottransmesh = mean(rottransmesh.Points, 1);

%Translate both meshes to the origin. 
centeredpoints = mesh.Points - centerofmesh;
centeredrotpoints = rottransmesh.Points - centerofrottransmesh;

%The covariance matrix tells us about the relationship between each of the 
%points and their rotated counterparts. By using the svd function for
%singular value decomposition, we get a U-matrix with left singular vectors
%and a V-matrix with right singular vectors. We are not interested in the
%singular values and use ~ for the S output. The left singular vectors
%describe the axes of the original mesh, the right singular vectors
%describe the axes of the rotated mesh. 
covarianceMatrix = centeredpoints' * centeredrotpoints;
[U, ~, V] = svd(covarianceMatrix);

%The next function makes our rotation matrix. It does so by multiplying our
%U-matrix with the transpose of our V-matrix (forming a composite
%translation).
rotationmatrix = U * V'; 

%Now that we have our output "rotationmatrix", we use it to rotate the original
%mesh within this very function. We do this to find the mean of the rotated
%original mesh, which is slightly different than the mean of the original
%mesh. 
funcrotpoints = mesh.Points*rotationmatrix;
centeroffuncrotmesh = mean(funcrotpoints, 1);

%Now that the meshes are both rotated into the same orientation, only the
%distance between them remains, which is described by the translation
%vector. It is simply found by subtracting the center of the the rotated
%original mesh from the center of the "rottransmesh".
translationvector = centerofrottransmesh - centeroffuncrotmesh;

end
