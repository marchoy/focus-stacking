function [im_all_in_focus] = focus(im_aligned, depth_map)
% Select the most in-focus portion in the focus stack, determined by the
% depth map, and combine them to form the all-in-focus image.

[Y, X, CH, ~] = size(im_aligned);

im_all_in_focus = zeros(Y, X, CH);

for y = 1:Y
    for x = 1:X
        im_all_in_focus(y, x, :) = im_aligned(y, x, :, depth_map(y, x));
    end
end
