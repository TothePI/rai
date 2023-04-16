clc;
clear;

w = fspecial('gaussian',4,2);
w = w./max(max(w));
w = w(:);
w = diag(w);  %debug  
disp(w);

patchx = [50,2,3,4;22,22,33,33;6,4,24,4;6,3,23,4];
patchy = [22,33,33,33;23,23,23,23;66,66,66,66;77,7,77,7];
[lamda0,u] = Grad(patchx,patchy,w);
disp(lamda0);
disp(u);
