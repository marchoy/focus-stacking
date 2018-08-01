% Filename: main.m

close all;

% Differentiate between different captured environments.
SCENE = 2;

FOCAL_LENGTH = 4.2; % mm

if SCENE == 1
    NUM_IMAGES = 4;
    FOCUS_DISTANCES = [70 88 160 250];
elseif SCENE == 2
    NUM_IMAGES = 12;
    FOCUS_DISTANCES = [70 75 84 88 98 120 130 160 180 200 210 250];
end

% Read images.
for i = 1:NUM_IMAGES
    fprintf('Reading Image %d', i);
    if SCENE == 1
        filename = sprintf('/MATLAB Drive/469 Project 5/images/Scene 1/IMG-08%d.JPG', i + 72);
    elseif SCENE == 2
        filename = sprintf('/MATLAB Drive/469 Project 5/images/Scene 2/IMG-08%d.JPG', i + 79);
    end        
    
    % Get image size from first image and create stack array.
    if i == 1
        im_temp = im2double(imread(filename));
        [HEIGHT, WIDTH, CH] = size(im_temp);
        im = zeros(HEIGHT, WIDTH, CH, NUM_IMAGES);
        im(:, :, :, i) = im_temp;
    else
        im(:, :, :, i) = im2double(imread(filename));
    end

    % Display images.
    %figure(); imshow(im(:, :, :, i));
end

% Align images in the focal stack.
disp('Aligning Images...');
im_aligned = align(FOCAL_LENGTH, FOCUS_DISTANCES, im);

% Create depth map from the image stack.
disp('Creating Depth Map...');
depth = depth_map(im_aligned);
im_depth = (NUM_IMAGES - depth)/NUM_IMAGES;
figure(); imshow(im_depth); print(sprintf('depth_map%02d', SCENE), '-djpeg', '-r600');

% Combined focused areas in the stack into one all-in-focus image.
disp('Focusing Images...');
im_all_in_focus = focus(im, depth);
figure(); imshow(im_all_in_focus); print(sprintf('all_in_focus%02d', SCENE), '-djpeg', '-r600');
