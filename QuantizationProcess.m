function [quantization, patchNumber] =  QuantizationProcess (im_GX, im_GY,patchSize, patchNumber, w , quantization)
    [H, W] = size(im_GX);
    for i1 = 1: 1: H - 2*floor(patchSize/2)-1
        for j1 = 1: 1: W - 2*floor(patchSize/2)-1
            patchX = im_GX(i1:1:i1+2*floor(patchSize/2), j1:1:j1+2*floor(patchSize/2));
            patchY = im_GY(i1:1:i1+2*floor(patchSize/2), j1:1:j1+2*floor(patchSize/2));
            [strength, coherence] = Grad(patchX, patchY, w);
            quantization(patchNumber, 1) = strength;
            quantization(patchNumber, 2) = coherence;
            patchNumber = patchNumber + 1;

        end
    end
end
