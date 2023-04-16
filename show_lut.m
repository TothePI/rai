clc;
clear;
close all;


load('filter.mat');

lut_show = zeros(Qcoherence * Qstrength * patchSize, Qangle * patchSize);


for coherence=0:1:Qcoherence-1
    for strength=0:1:Qstrength-1
        for angle=0:1:Qangle-1
            
            idx = angle*Qstrength*Qcoherence+strength*Qcoherence+coherence+1;
            tmp_h = h(:,1,idx);
            tmp_h = reshape(tmp_h, patchSize,patchSize);

            tmp_h = tmp_h ./ (max(max(tmp_h)));

            cury = coherence * strength * patchSize;
            curx = angle * patchSize;

            for i=1:1:patchSize
                for j=1:1:patchSize

                    lut_show(cury+i, curx+j) = tmp_h(i,j);

                end
            end
            

        end
    end
end

imshow(uint8(lut_show));