function [output] = noiseSelectorTester(img, rumore)
    disp(">> noiseSelector START <<");
    disp("Tipo rumore: " + rumore);
    % (eventualmente) disp delle dimensioni dell’immagine:
    disp(size(img));

    % il codice originale
    if strcmpi(rumore, 'gaussian')
        final = gaussNoiseRemover(img);
    % …
    end

    output = final;
    disp(">> noiseSelector END <<");
end
