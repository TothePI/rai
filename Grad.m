function [lamda, u] = Grad(patchX,patchY,weight)
    gx = patchX(:);
    gy = patchY(:);
    G = [gx, gy]; %debug
    x0 = G' * weight;
    x = x0  * G;
    [w, v] = eig(x);
    v=diag(v);
    lamda = max(v);
    lamda0 = sqrt(max(v));
    lamda1 = sqrt(min(v));
    u = (lamda0 - lamda1)/(lamda0 + lamda1 + 0.00000000000000001);

end