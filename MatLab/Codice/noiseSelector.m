function [output] = noiseSelector(i, rumore)
    disp(">> noiseSelector START <<");
    disp("Tipo rumore: " + rumore);
    disp(size(i));

    if strcmpi(rumore, 'erlang_rayleigh')
        final = erlangRayleighNoiseRemover(i);
    elseif strcmpi(rumore, 'gaussian')
        final = gaussNoiseRemover(i);
    elseif strcmpi(rumore, 'original')
        final = i;
    elseif strcmpi(rumore, 'periodic')
        final = periodicNoiseRemover(i);
    elseif strcmpi(rumore, 'salt_pepper')
        final = saltpepperNoiseRemover(i);
    elseif strcmpi(rumore, 'speckle')
        final = speckleNoiseRemover(i);
    elseif strcmpi(rumore, 'striping_horizontal')
        final = horizontalStripingNoiseRemover(i);
    elseif strcmpi(rumore, 'striping_vertical')
        final = verticalStripingNoiseRemover(i);
    elseif strcmpi(rumore, 'uniform')
        final = uniformNoiseRemover(i);
    else
        error('Tipo rumore non riconosciuto');
    end

    % Salva immagine in file temporaneo
    tempFileName = 'temp_output.png';
    imwrite(final, tempFileName);

    % Leggi file come byte
    fid = fopen(tempFileName, 'rb');
    imgData = fread(fid, '*uint8');
    fclose(fid);

    % Codifica base64
    encoded = matlab.net.base64encode(imgData);

    % Restituisci stringa base64
    output = encoded;

    % Cancella file temporaneo
    delete(tempFileName);
end
