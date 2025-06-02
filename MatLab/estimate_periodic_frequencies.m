function [fx_est, fy_est, peak_coords] = estimate_periodic_frequencies(I_rgb)

% Se RGB, converti a grigio (oppure media dei canali)
if size(I_rgb, 3) == 3
    I_gray = rgb2gray(I_rgb);
else
    I_gray = I_rgb;
end

[M, N] = size(I_gray);

% Calcola spettro di Fourier
F = fftshift(fft2(I_gray));
F_mag = log(1 + abs(F));

% Sopprimi il centro per evitare il picco a bassa frequenza (contenuto immagine)
margin = 10;
F_mag_center_suppressed = F_mag;
F_mag_center_suppressed(M/2-margin:M/2+margin, N/2-margin:N/2+margin) = 0;

% Trova coordinate del picco massimo residuo
[max_val, linear_idx] = max(F_mag_center_suppressed(:));
[v_peak, u_peak] = ind2sub(size(F_mag_center_suppressed), linear_idx);

% Centra le coordinate rispetto al centro dello spettro
u0 = u_peak - (N/2 + 1);
v0 = v_peak - (M/2 + 1);

% Stima delle frequenze normalizzate (cicli per pixel)
fx_est = u0 / N;
fy_est = v0 / M;

% Output anche le coordinate pixel
peak_coords = [u_peak, v_peak];
end
