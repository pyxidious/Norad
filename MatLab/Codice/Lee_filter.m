function J = Lee_filter(I, sz, noise_var)
% lee_filter_noisy – filtro di Lee su immagine speckle rumorosa
%
% J = lee_filter_noisy(I, sz, noise_var)
%   I         – immagine 2D rumorosa (double in [0,1] o uint8/uint16)
%   sz        – dimensione finestra (es. 5 per 5×5)
%   noise_var – varianza stimata del rumore speckle (se omesso: stimata globalmente)
%
% Ritorna J: immagine filtrata

    I = double(I);
    if nargin < 3 % Se non mi hai passato la noise_variance devo stimare la varianza dell'immagine
        % Stima varianza rumore come mediana delle varianze locali
        local_var = stdfilt(I, true(sz)).^2; % Varianza in un filtro grande quanto sz, deviazione standard al quadrato è varianza
        noise_var = median(local_var(:)); % Local variance calcolata in tutte le aree 5x5 dell'img e fa una mediana, questa è
        % varianza globale
    end

    % Media e media dei quadrati locali (filtro uniforme)
    h = fspecial('average', sz);
    mean_local = imfilter(I, h, 'replicate');
    mean_sq_local = imfilter(I.^2, h, 'replicate');
    var_local = mean_sq_local - mean_local.^2; % mean_local = media

    % Calcolo del coefficiente adattivo W
    W = var_local ./ (var_local + noise_var);
    W(isnan(W)) = 0;  % evita divisioni per zero

    % Applica il filtro di Lee
    J = mean_local + W .* (I - mean_local); % Al pixel ci sottrae la media, lo moltiplica per W e ci sottrae nuovamente la media
    J = im2uint8(mat2gray(J)); % scala su [0,1], poi uint8
end