clc;
clear;
close all;


patchx = [50,2,3,4;22,22,33,33;6,4,24,4;6,3,23,4];

w = fspecial('gaussian',4,2);
w = w./max(max(w));
w = w(:);
wei = diag(w);  %debug 

[im_GY,im_GX] = gradient(patchx);        
disp(im_GY);
disp(im_GX);
im_GY = im_GY';
im_GX = im_GX';
stre=[0.3,0.6];
cohe=[0.3,0.6];
[angle, strength, coherence ] = HashTable(im_GX, im_GY, ...
    wei , 24, 3, 3, stre, cohe);