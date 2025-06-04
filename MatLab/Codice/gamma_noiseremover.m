function [img_noisy, img_denoisedw, peaksnr_noisy, peaksnr_denoised] = gamma_noiseremover(nome_img)
% gammaNoiseWienerFilter Aggiunge rumore Gamma zero-mean a un'immagine e applica filtro di Wiener
%
% Input:
%   nome_img - nome file immagine (stringa, es. 'Cat_August_2010-4.jpg')
%
% Output:
%   img_noisy        - immagine con rumore Gamma zero-mean
%   img_denoisedw    - immagine filtrata con Wiener filter
%   peaksnr_noisy    - PSNR tra immagine originale e immagine rumorosa
%   peaksnr_denoised - PSNR tra immagine originale e immagine filtrata

% Recupero percorso immagine attiva e costruisco il percorso completo
fullFileName = matlab.desktop.editor.getActiveFilename;
folderPath = fileparts(fullFileName);
folderPath = strrep(folderPath, 'MatLab', '');  % se necessario modificare stringa
folderPath = fullfile(folderPath, 'Python/dataset', 'original', nome_img);

% Lettura immagine originale
i2 = imread(folderPath);

% Conversione in double [0,1]
I = im2double(i2);

% Parametri rumore Gamma
a = 50;
b = 10;
scale = 1/a;

% Generazione rumore Gamma
noiseGamma = gamrnd(b, scale, size(I));

% Rimozione media per ottenere rumore zero-mean
noise_zero_mean = noiseGamma - (b * scale);

% Immagine rumorosa
img_noisy = I + noise_zero_mean;
img_noisy = min(max(img_noisy, 0), 1);  % clamp valori

% Applicazione filtro di Wiener (finestra 5x5)
img_denoisedw = img_noisy;
for c = 1:3
    img_denoisedw(:,:,c) = wiener2(img_noisy(:,:,c), [5 5]);
end

% Calcolo PSNR
I_originale = I;
[peaksnr_noisy, ~] = psnr(img_noisy, I_originale);
[peaksnr_denoised, ~] = psnr(img_denoisedw, I_originale);

% Stampa risultati
fprintf('PSNR tra originale e rumorosa: %.4f dB\n', peaksnr_noisy);
fprintf('PSNR tra originale e filtro Wiener: %.4f dB\n', peaksnr_denoised);

% Visualizzazione (facoltativa, si può commentare)
figure;
subplot(1,3,1);
imshow(I);
title('Originale');

subplot(1,3,2);
imshow(img_noisy);
title('Rumore Gamma zero-mean');

subplot(1,3,3);
imshow(img_denoisedw);
title('Filtro Wiener applicato');

end
