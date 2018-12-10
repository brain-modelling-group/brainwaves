function v=phaseflow_cnem(yphasep,loc,dt,speedonlyflag)
%  v = phaseflow_cnem(yphasep,loc,dt)
% Calculate instantaneous phase flow at every time point
%
% Inputs: yphasep - times-by-regions matrix of phases, assumed unwrapped
%         loc - regions-by-3 matrix of points
%         dt - time step
% 
% Outputs: v - velocity struct, with fields:
%            -- vnormp - speed
%            -- vxp - x component
%            -- vyp - y component
%            -- vzp - z component
%
% JA Roberts, QIMR Berghofer, 2018

if nargin<4
    speedonlyflag=0;
end

% assume phases unwrapped in time already
[~,dphidtp]=gradient(yphasep,dt);
fprintf('dphidt done...')

shpalpha=30; % alpha radius; may need tweaking depending on geometry
shp=alphaShape(loc,shpalpha);
bdy=shp.boundaryFacets;
B=grad_B_cnem(loc,bdy);

np=size(yphasep,1);

dphidxp=zeros(size(yphasep));
dphidyp=zeros(size(yphasep));
dphidzp=zeros(size(yphasep));

for j=1:np
    yphase=yphasep(j,:);
    yphase=yphase(:);
    
    % wrap phases by differentiating exp(i*phi)
    yphasor=exp(1i*yphase);
    gradphasor=grad_cnem(B,yphasor);
    
    dphidxp(j,:)=real(-1i*gradphasor(:,1).*conj(yphasor));
    dphidyp(j,:)=real(-1i*gradphasor(:,2).*conj(yphasor));
    dphidzp(j,:)=real(-1i*gradphasor(:,3).*conj(yphasor));
end
fprintf('gradphi done...')

normgradphip=sqrt(dphidxp.^2+dphidyp.^2+dphidzp.^2);
% magnitude of velocity = dphidt / magnitude of grad phi, as per Rubino et al. (2006)
vnormp=abs(dphidtp)./normgradphip;

v.vnormp=vnormp;
if ~speedonlyflag
    v.vxp=vnormp.*-dphidxp./normgradphip; % magnitude * unit vector component
    v.vyp=vnormp.*-dphidyp./normgradphip;
    v.vzp=vnormp.*-dphidzp./normgradphip;
end
fprintf('v done...')
