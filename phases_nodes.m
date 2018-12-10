function yphasep=phases_nodes(yp)
%  yphasep = phases_nodes(yp)
% calculate instantaneous phase at all nodes

fprintf('calculating phases...')

if length(yp)<100000
    % short but inefficient with memory
    tic
    % calculate phase
    yphasep=unwrap(angle(hilbert(bsxfun(@minus,yp,mean(yp)))));
    fprintf('done \n')
    toc
else
    % inelegant but uses less memory
    tic
    yphasep=zeros(size(yp));
    nn=size(yp,2);
    for jj=1:nn
        y=yp(:,jj);
        yphasep(:,jj)=unwrap(angle(hilbert(y-mean(y))));
    end
    fprintf('done \n')
    toc
    
end