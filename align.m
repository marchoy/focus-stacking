function [im_aligned] = align(focal_length, focus_distances, im)
% Aligns the images in the focal stack.

[Y, X, ~, NUM_IMAGES] = size(im);

im_aligned = zeros(size(im));

for i = 1:NUM_IMAGES
    fprintf('Aligning Image %d\n', i);
    % Determine magnification factor using the thin lens equation.
    lens_to_object_distance = focus_distances(i);
    lens_to_sensor_distance = 1/((1/focal_length)-(1/lens_to_object_distance));
    
    % Magnification relative to the first image.
    if i == 1
        base_l2s_distance = lens_to_sensor_distance;
        im_aligned(:, :, :, i) = im(:, :, :, i);
    else
        m = lens_to_sensor_distance/base_l2s_distance;
        
        % Transform image.
        tform = affine2d([1/m 0 0; 0 1/m 0; 0 0 1]);
        im_temp = imwarp(im(:, :, :, i), tform);
        
        % Crop image about center to original size.
        [y, x, ~] = size(im_temp);
        im_aligned(:, :, :, i) = imcrop(im_temp, [round((x-X)/2) round((y-Y)/2) X-1 Y-1]);
    end
    
    % Display aligned images.
    %figure(); imshow(im_aligned(:, :, :, i));
end
