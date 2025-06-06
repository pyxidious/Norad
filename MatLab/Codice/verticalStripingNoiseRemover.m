function [I_denoised] = verticalStripingNoiseRemover(i)
I_rgb = im2double(i);
[M, N, C] = size(I_rgb);
I_denoised = zeros(size(I_rgb));
windowSize = 100;
for c = 1:C
    channel = I_rgb(:,:,c);
    p = mean(channel, 1);
    p_smooth = medfilt1(p, windowSize, 'truncate');
    stripe_profile = p - p_smooth;
    stripe_matrix = repmat(stripe_profile, M, 1);
    denoised_channel = channel - stripe_matrix;
    denoised_channel = min(max(denoised_channel, 0), 1);
    I_denoised(:,:,c) = denoised_channel;
end
end