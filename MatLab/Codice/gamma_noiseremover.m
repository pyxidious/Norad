function [img_denoisedw] = gamma_noiseremover(i)
img_denoisedw = i;
    for c = 1:3
        img_denoisedw(:,:,c) = wiener2(i(:,:,c), [5 5]);
    end
end
