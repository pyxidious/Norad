function [output] = saltpepperNoiseRemover(input)
    if size(input, 3) == 3
        img_denoised = input;
        for c = 1:3
            img_denoised(:,:,c) = medfilt2(input(:,:,c), [3 3]);
        end
        output = img_denoised;
    else
        output = medfilt2(input, [3 3]);
    end
end


% Adaptive Median Filter (filtro che fa anche un po' di smoothing)