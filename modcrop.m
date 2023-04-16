function out = modcrop(im_gray)

    [h,w] = size(im_gray);
    h = h - mod(h,2);
    w = w - mod(w,2);

    out = im_gray(1:1:h, 1:1:w);

end