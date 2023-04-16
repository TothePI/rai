clc;
clear;
close all;

trainPath = 'trainingData';
%%
R = 2;                           % Upscaling factor=2
patchSize = 11;                  % Pacth Size=11
gradientSize = 9;                % Gradient Size = 9
Qangle = 24;                     % Quantization factor of angle =24
Qstrength = 3;                   % Quantization factor of strength =3
Qcoherence = 3;                  % Quantization factor of coherence =3
stre = zeros((Qstrength-1),1);     % Strength boundary
cohe = zeros((Qcoherence-1),1);    % Coherence boundary    

Q = zeros( patchSize*patchSize, patchSize*patchSize, R*R, Qangle*Qstrength*Qcoherence);  % Eq.4
V = zeros( patchSize*patchSize, R*R, Qangle*Qstrength*Qcoherence);                       % Eq.5
h = zeros( patchSize*patchSize, R*R, Qangle*Qstrength*Qcoherence);
mark = zeros(R*R, Qangle*Qstrength*Qcoherence);                  % statical distribution of patch numbers in each bucket
w = fspecial('gaussian',patchSize,2);
w = w./max(max(w));
w = w(:);
w = diag(w);  %debug                                             % Diagnal weighting matrix Wk in Algorithm 1

instance = 20000000;  % use 20000000 patches to get the Strength and coherence boundary
patchNumber = 1;   % patch number has been used
quantization = zeros(instance, 2); % quantization boundary
filelist = readImages(trainPath);
for k=1:length(filelist)
    if(k > 30)
        break;
    end
    fprintf('\nProcessing get boundary%s...\n',filelist(k).name);
    im = imread(fullfile(trainPath,filelist(k).name));
%     im = im2double(im);
    im_ycbcr = rgb2ycbcr(im);
    im = im_ycbcr(:,:,1);
    im = modcrop(im);
    [H,W]=size(im);
    im_LR = PrepareLR(im,patchSize,R);         % Prepare the cheap-upscaling images (optional: JPEG compression)
    [im_GX,im_GY] = gradient(im_LR);        % Calculate the gradient images
    [quantization, patchNumber] = QuantizationProcess (im_GX, im_GY,patchSize, patchNumber, w, quantization);  % get the strength and coherence of each patch
    if (patchNumber > instance/2)
        break
    end
end
%%
% uniform quantization of patches, get the optimized strength and coherence boundaries
% patchNumber = 6;
% Qstrength = 3;
% Qcoherence = 3;
% quantization = [11,33,7,34,2,6,8; 2,4,9,3,2,44,98];
% quantization = quantization';
% stre = zeros((Qstrength-1),1);     % Strength boundary
% cohe = zeros((Qcoherence-1),1);    % Coherence boundary  

quantization_stre = quantization(1:patchNumber,1);
quantization_cohe = quantization(1:patchNumber,2);
quantization_stre = sort(quantization_stre);
quantization_cohe = sort(quantization_cohe);
for i = 1:1:Qstrength-1
    stre(i) = quantization_stre(floor( i*patchNumber/Qstrength) );
end

for i = 1:1:Qcoherence-1
    cohe(i) = quantization_cohe(floor( i*patchNumber/Qcoherence) );
end
%%
imagecount = 1;
filelist = readImages(trainPath);
for k=1:length(filelist)
    if(k > 30)
        break;
    end
    fprintf('\nProcessing training %s...\n',filelist(k).name);
    im = imread(fullfile(trainPath,filelist(k).name));
    im_ycbcr = rgb2ycbcr(im);
    im = im_ycbcr(:,:,1);
    im = modcrop(im);
    [H,W]=size(im);
    im_LR = PrepareLR(im,patchSize,R);         % Prepare the cheap-upscaling images (optional: JPEG compression)
    im_HR = im2double(im);
    [im_GX,im_GY] = gradient(im_LR);        % Calculate the gradient images
    [Q, V, mark] = TrainProcess (im_LR, im_HR, im_GX, im_GY, ...
            patchSize, w, Qangle, Qstrength, Qcoherence, stre, cohe, R, Q, V, mark);  % get the strength and coherence of each patch
    imagecount = imagecount + 1;
end

 for t=1:R*R
    for j=1:Qangle*Qstrength*Qcoherence
        erro=0;
        while(true)
            if(sum(sum(Q(:,:,t,j)))<100)
                break;
            end
            if(det(Q(:,:,t,j))<1)
                erro=erro+1;
                Q(:,:,t,j)=Q(:,:,t,j)+eye(patchSize^2)*sum(sum(Q(:,:,t,j)))*0.000000005;
            else
                 h(:,t,j)=Q(:,:,t,j)\V(:,t,j);
                break;
            end
        end
    end
 end

save('filter.mat','h','patchSize','Qangle','Qstrength','Qcoherence','R');



