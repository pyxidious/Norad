function [I_denoised] = horizontalStripingNoiseRemover(i)
I_rgb = im2double(i);
[M, N, C] = size(I_rgb);
I_denoised = zeros(size(I_rgb));
windowSize = 75;
for c = 1:C
    channel = I_rgb(:,:,c);
    p = mean(channel, 2);
    p_smooth = medfilt1(p, windowSize, 'truncate');
    stripe_profile = p - p_smooth;
    stripe_matrix = repmat(stripe_profile, 1, N);
    channel_denoised = channel - stripe_matrix;
    channel_denoised = min(max(channel_denoised, 0), 1);
    I_denoised(:,:,c) = channel_denoised;
end
end