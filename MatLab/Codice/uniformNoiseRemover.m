function output = uniformNoiseRemover(noisy_img)
    % Se l'immagine è a colori, converti in YCbCr e applica il filtro solo al canale di luminanza
    if size(noisy_img, 3) == 3
        ycbcr = rgb2ycbcr(noisy_img);
        y = ycbcr(:, :, 1);

        % Applica il filtro Wiener sul canale di luminanza
        y_denoised = wiener2(y, [5 5]);

        % Ricompone l'immagine
        ycbcr(:, :, 1) = y_denoised;
        output = ycbcr2rgb(ycbcr);
    else
        % Se l'immagine è in scala di grigi
        output = wiener2(noisy_img, [5 5]);
    end
    
end
