function im_LR = PrepareLR(im, patchSize, R)
    patchMargin = floor(patchSize/2);
    [H, W] = size(im);
    imL = imresize(im, 1 / R, 'bicubic'); %debug size
    % cv2.imwrite('Compressed.jpg', imL, [int(cv2.IMWRITE_JPEG_QUALITY), 85])
    % imL = cv2.imread('Compressed.jpg')
    % imL = imL[:,:,0]   # Optional: Compress the image
    imL = imresize(imL, [H, W], 'bicubic');
    imL = im2double(imL);
    im_LR = imL;

end