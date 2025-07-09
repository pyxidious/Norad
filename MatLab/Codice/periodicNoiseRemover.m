function best_img = periodicNoiseRemover(i)

% 1) Carica l’immagine RGB e normalizzala in [0,1]
[M, N, C]    = size(i);   % C = 3 per RGB
I_noisy_rgb = im2double(i);

% 3) Calcola FFT shiftata per ciascun canale
Fshift_rgb = zeros(M, N, C);
for ch = 1:C
    F = fft2(I_noisy_rgb(:,:,ch));
    Fshift_rgb(:,:,ch) = fftshift(F);
end

% 4) Stima automatica delle coordinate dei picchi (maggiore intensità)
magSum = zeros(M, N);
for ch = 1:C
    magSum = magSum + abs(Fshift_rgb(:,:,ch));
end
magAvg = magSum / C;

% Maschera intorno al DC (±5 px) per evitare di rilevarlo
u_center = floor(N/2) + 1;
v_center = floor(M/2) + 1;
dc_half = 5;
u_min_dc = max(u_center - dc_half, 1);
u_max_dc = min(u_center + dc_half, N);
v_min_dc = max(v_center - dc_half, 1);
v_max_dc = min(v_center + dc_half, M);
magAvg(v_min_dc:v_max_dc, u_min_dc:u_max_dc) = 0;

% Trova il primo picco (positivo)
[~, idx1] = max(magAvg(:));
[v_pos, u_pos] = ind2sub([M, N], idx1);

% Elimina il primo picco per trovare il secondo
magAvg(idx1) = 0;
[~, idx2] = max(magAvg(:));
[v_neg, u_neg] = ind2sub([M, N], idx2);

% 5) Calcolo delle frequenze stimate (in cicli/pixel)
dx_pos = u_pos - u_center;  % offset orizzontale dal centro
dy_pos = v_pos - v_center;  % offset verticale dal centro

fx_est = abs(dx_pos) / N;
fy_est = abs(dy_pos) / M;

% 6) Definisci i valori di 'd' da provare
D_values = [3, 5, 7, 9, 11, 13];
numD     = numel(D_values);

% Prealloca array per le metriche e le immagini filtrate
NIQEs    = zeros(1, numD);
I_filt_all_rgb = cell(1, numD);

% 8) Loop su ciascun valore di d: filtro notch + calcolo metriche
for k = 1:numD
    d = D_values(k);
    
    % Costruisci la maschera notch 2D
    mask2D = ones(M, N);
    
    % Picco positivo
    umin  = max(u_pos - d, 1);
    umax  = min(u_pos + d, N);
    vmin  = max(v_pos - d, 1);
    vmax  = min(v_pos + d, M);
    mask2D(vmin:vmax, umin:umax) = 0;
    
    % Picco negativo
    umin2 = max(u_neg - d, 1);
    umax2 = min(u_neg + d, N);
    vmin2 = max(v_neg - d, 1);
    vmax2 = min(v_neg + d, M);
    mask2D(vmin2:vmax2, umin2:umax2) = 0;
    
    % Replica la maschera per i 3 canali
    mask_rgb = repmat(mask2D, [1, 1, C]);
    
    % Applica la maschera notch e ricostruisci ogni canale
    I_rec_rgb = zeros(M, N, C);
    for ch = 1:C
        Fshift_notched = Fshift_rgb(:,:,ch) .* mask2D;
        F_notched      = ifftshift(Fshift_notched);
        I_rec_ch       = real(ifft2(F_notched));
        I_rec_ch       = min(max(I_rec_ch, 0), 1);
        I_rec_rgb(:,:,ch) = I_rec_ch;
    end
    
    % Memorizza l’immagine ricostruita
    I_filt_all_rgb{k} = I_rec_rgb;
    
    % Calcola metriche no-reference sull’immagine RGB ricostruita
    NIQEs(k)    = niqe(I_rec_rgb);
end
[~, idx_best] = min(NIQEs);  % o BRISQUEs, o combinazione
best_img = I_filt_all_rgb{idx_best};
