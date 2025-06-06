function [I_sum] = horizontalStripingNoiseRemover(i)
I_noisy = im2double(i);

kernel_size = 3;
sigma = 1;

lowpass_gaussian = fspecial('gaussian', kernel_size, sigma);
impulse = zeros(kernel_size);
impulse(ceil(kernel_size/2), ceil(kernel_size/2)) = 1;
highpass_gaussian = impulse - lowpass_gaussian;
I_highpass = zeros(size(I));
I_lowpass = zeros(size(I));
for c = 1:3
I_highpass(:,:,c) = imfilter(I(:,:,c), highpass_gaussian, 'replicate');
I_lowpass(:,:,c)  = imfilter(I(:,:,c), fspecial('average', [3 3]), 'replicate');
end
imshow(I_highpass)
imshow(I_lowpass)
I_sum = I_highpass + I_lowpass;
imshow(I_sum)
end