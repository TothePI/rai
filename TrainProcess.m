function [Q, V, mark] = TrainProcess(im_LR, im_HR, im_GX, im_GY, ...
            patchSize, w, Qangle, Qstrength, Qcoherence, stre, cohe, R, Q, V, mark)
    [H, W] = size(im_HR);
    for i1 = 1: 1: H - 2*floor(patchSize/2)-1
        for j1 = 1: 1: W - 2*floor(patchSize/2)-1
            
            patch = im_LR(i1:1:i1+2*floor(patchSize/2), j1:1:j1+2*floor(patchSize/2));
            patchX = im_GX(i1:1:i1+2*floor(patchSize/2), j1:1:j1+2*floor(patchSize/2));
            patchY = im_GY(i1:1:i1+2*floor(patchSize/2), j1:1:j1+2*floor(patchSize/2));

            [angle, strength, coherence ] = HashTable(patchX, patchY, w, Qangle, Qstrength, Qcoherence, stre, cohe);
            patch1 = patch';
            patch1 = patch1(:);
            patchL = reshape(patch1,1,size(patch1,1)*size(patch1,2));
            t = mod(i1,R)*R + mod(j1,R) + 1; 
            j = angle*Qstrength*Qcoherence+strength*Qcoherence+coherence+1;
            A = patchL'*patchL;
            Q(:,:,t,j) = Q(:,:,t,j)+A;
            im_HR_cur = im_HR(i1+floor(patchSize/2), j1+floor(patchSize/2));
            b1 = patchL'*im_HR_cur;
            V(:,t,j) = V(:,t,j)+b1;
            mark(t,j) = mark(t,j) + 1;

        end
    end
end