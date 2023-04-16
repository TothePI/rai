clc;
clear;
close all;

patch = [1,2,3,4;22,22,33,33;6,4,24,4;6,3,23,4];
disp(patch)
patch1 = patch';
patch1 = patch1(:);
A = reshape(patch1,1,size(patch1,1)*size(patch1,2));
disp(A)