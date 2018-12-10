function B=grad_B_cnem(XYZ,IN_Tri_Ini)
%  B = grad_B_cnem(XYZ,[IN_Tri_Ini])
% Calculate the matrix B for calculating the gradient \nabla V evaluated at
% 3-D scattered points in matrix XYZ
%
% Grad_V=B*V; Grad_V_mat=reshape(Grad_V,4,[])';
% 
% IN_Tri_Ini is the triangulation of the boundary nodes
%
% Uses CNEM.
%
%
% JA Roberts, QIMR Berghofer, 2018

if nargin<2
    IN_Tri_Ini=[];
end

Sup_NN_GS = 1;
Type_FF = 0;% 0 -> Sibson, 1 -> Laplace, 2 -> Linear fem

[GS,XYZ,IN_Tri_Ini,IN_Tri,IN_Tet,INV_NN,PNV_NN,IN_New_Old,IN_Old_New]=...
m_cnem3d_scni(XYZ,IN_Tri_Ini,Type_FF,Sup_NN_GS);

nb_var=1;
B= cal_B_Mat(GS,nb_var);
