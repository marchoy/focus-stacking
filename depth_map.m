function [im_depth_map] = depth_map(im)
% Quantifies the local sharpness in each image of the focal stack using
% Laplacian filtering (sharpness) followed by Gaussian blurring. A
% depth map of the scene is built by identifying the sharp regions of
% each image relative to their position in the image stack.

% Images.
[Y, X, ~, NUM_IMAGES] = size(im);
im_gray = zeros(Y, X, NUM_IMAGES);
im_filtered = zeros(Y, X, NUM_IMAGES);
im_depth_map = ones(Y, X);

% Filter.
alpha = 1;
LAPLACIAN = fspecial('laplacian', alpha);

disp('Applying Filters...');

% Convert images to grayscale and apply Laplacian and Gaussian filters.
for i = 1:NUM_IMAGES
    % Convert image to grayscale.
    im_gray(:, :, i) = rgb2gray(im(:, :, :, i));
    
    % Histogram equalization to enhance effect of Laplacian filter.
    im_gray(:, :, i) = histeq(im_gray(:, :, i));

    % Apply Laplacian filter.
    im_filtered(:, :, i) = histeq(imfilter(im_gray(:, :, i), LAPLACIAN));
    
    % Display Laplacian.
    %figure(); imshow(im_filtered(:, :, i)); %print(sprintf('laplacian%02d', i), '-djpeg', '-r600');
    
    % Apply Gaussian filter.
    im_filtered(:, :, i) = imgaussfilt(im_filtered(:, :, i), 9);
    
    % Display Gaussian filter.
    %figure(); imshow(im_filtered(:, : , i)); %print(sprintf('gaussian%02d', i), '-djpeg', '-r600');
end

disp('Building Depth Map...');

% Build the depth map.
for y = 1:Y
    for x = 1:X
        sharpest_image = 1;
        for i = 2:NUM_IMAGES
            if im_filtered(y, x, sharpest_image) < im_filtered(y, x, i)
                sharpest_image = i;
            end
        end
        im_depth_map(y, x) = sharpest_image;
    end
end
