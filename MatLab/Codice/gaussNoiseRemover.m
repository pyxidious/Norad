function [output] = gaussNoiseRemover(input)
% Controllo se Double
if ~isa(input, 'double')
    input = im2double(input);
end

% Controlla se a 3 canali
if size(input,3) ~= 3
    error('L''immagine deve avere 3 canali RGB');
end

input_denoised = zeros(size(input));
for c = 1:3
    input_denoised(:,:,c) = wiener2(input(:,:,c), [4 4]);
end
output = input_denoised;

% Possiamo rimuoverlo con media aritmetica o con media geometrica
% AdaptiveFilter => stimano il rumore dell'immagine
end
