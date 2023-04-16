function [angle, lamda, u] = HashTable(patchX, patchY, weight, Qangle, Qstrength, Qcoherence, stre, cohe)
    if(length(stre) ~= (Qstrength-1) && length(cohe) ~= (Qcoherence-1))
        disp('error');
    end

    gx = patchX(:);
    gy = patchY(:);
%     disp('gx');
%     disp(gx);
%     disp('gy');
%     disp(gy);


    G = [gx, gy]; %debug
    x0 = G' * weight;
%     disp('weight');
%     disp(weight);
%     disp('G');
%     disp(G);
%     disp('G.T');
%     disp(size(G'));
%     disp(G');
%     disp('X0');
%     disp(x0);
    x = x0  * G;
    [eigvector, eigvalue] = eig(x); %[V,D] = eig(A) W:vector v:eig value
%     disp('eig x');
%     disp(x);
% 
%     disp('eigvector');
%     disp(eigvector);
% 
%     disp('eigvalue');
%     disp(eigvalue);

    v=diag(eigvalue);
    
    lamda = max(v);

    lamda0 = sqrt(max(v));
    lamda1 = sqrt(min(v));
    u = (lamda0 - lamda1)/(lamda0 + lamda1 + 0.00000000000000001);

    x=eigvector(1,1); %debug
    y=eigvector(2,1);

%     if y<0
%         x=-x;
%         y=-y;
%     end

%     disp('x，y');
%     disp(x);
%     disp(y);

    theta = atan2(x, y);

%     disp('theta');
%     disp(theta);
%     disp(lamda);
%     disp(u);

    if(theta<0)
        theta = theta+pi;
    end

%     disp('add pi theta');
%     disp(theta);
    angle = floor(theta/((pi+0.000000000001)/Qangle));

    if(lamda<stre(1))
        lamda=0;
    elseif(stre(1)<=lamda && lamda<=stre(2))
        lamda=1;
    else
        lamda=2;
    end

    if(u<cohe(1))
        u=0;
    elseif(cohe(1)<u && u<cohe(2))
        u=1;
    else
        u=2;
    end



end