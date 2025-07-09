function [output, niqe_noise, niqe_denoised] = noiseSelector(i, rumore)
    if strcmpi(rumore, 'erlang_rayleigh')
        final = gamma_noiseremover(i);
    elseif strcmpi(rumore, 'gaussian')
        final = gaussNoiseRemover(i);
    elseif strcmpi(rumore, 'original')
        final = i;
    elseif strcmpi(rumore, 'periodic')
        final = periodicNoiseRemover(i);
    elseif strcmpi(rumore, 'salt_pepper')
        final = saltpepperNoiseRemover(i);
    elseif strcmpi(rumore, 'speckle')
        final = Lee_filter(i, 5);
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
    niqe_noise = niqe(i);
    niqe_denoised = niqe(final);

    % Cancella file temporaneo
    delete(tempFileName);
end
