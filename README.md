# Focus Stacking
Focus stacking is an image processing technique where a series of images focused at multiple planes are combined allowing full control over depth of field. In this project, focus stacking is implemented to generate an all-in-focus image. The implementation is done in four stages: image capture, alignment, in-focus detection and blending.

### Image Capture
A series of images of a static scene are captured at differing focal depths.
![Focus stack images](/images/focus_stack.png)

### Image Alignment
The images in the focus stack are aligned using a calculated lens-to-sensor distance for each image that is proportional to the image size (magnification from lens adjustment) captured by the detector.

### Sharpness Detection
The images are filtered using a Laplacian operator for edge detection, and then blurred using a Gaussian filter to map a genaral area of in-focusness.

### Depth Map
The images of the filtered stack that contain the highest intensity value pixels are recorded into a single image and scaled to the range 0 to 1 to form a depth map.

<img src="/images/depth_map01.jpg" alt="Depth map 4 images" width="45%"><img src="/images/depth_map02.jpg" alt="Depth map 12 images" width="45%">

### Image Blending
The depth map is used to combine the in-focus pixels from the original stack images.

<img src="/images/all_in_focus01.jpg" alt="All in focus 4 images" width="45%"><img src="/images/all_in_focus02.jpg" alt="All in focus 12 images" width="45%">
