function out=grad_cnem(XYZ,V,IN_Tri_Ini)
%  gradV = grad_cnem(XYZ,V,[IN_Tri_Ini])
% Gradient \nabla V evaluated at 3-D scattered points in matrix XYZ
%
% Alternatively, can call 
%  gradV = grad_cnem(B,V);
% to use a precalculated B matrix
%
% Uses CNEM.
%
%
% JA Roberts, QIMR Berghofer, 2018

if nargin<3
    IN_Tri_Ini=[];
end

if size(XYZ,2)==3 % if loc matrix, calculate the B matrix
    B = grad_B_cnem(XYZ,IN_Tri_Ini);
else % already given the B matrix
    B=XYZ;
end

Grad_V=B*V;
Grad_V_mat=reshape(Grad_V,4,[]).';

out=Grad_V_mat(:,1:3); % 4th column is V