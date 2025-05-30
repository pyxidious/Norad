function output = imageReader(nome_img)
% imageReader cerca e legge la prima immagine (jpg, png, tiff) nella cartella
% che contiene la sottostringa nome_img nel nome del file.
% Se nome_img è vuoto, legge la prima immagine disponibile.

if nargin < 1
    nome_img = '';
end

fullFileName = matlab.desktop.editor.getActiveFilename;
folderPath = fileparts(fullFileName);
folderPath = strrep(folderPath, 'MatLab', ''); % Rimuove "MatLab" dalla stringa percorso
folderPath = fullfile(folderPath, 'MatLab', 'Test'); % Costruisce il percorso completo

extensions = {'*.jpg', '*.png', '*.tiff'};
output = [];
foundImage = false;

% Se nome_img è vuoto, prendo semplicemente la prima immagine valida
if isempty(nome_img)
    for k = 1:length(extensions)
        files = dir(fullfile(folderPath, extensions{k}));
        if ~isempty(files)
            fullImagePath = fullfile(folderPath, files(1).name);
            disp("Sto leggendo l'immagine: " + fullImagePath); % debug
            output = imread(fullImagePath);
            foundImage = true;
            break;
        end
    end
else
    % Se nome_img è specificato, cerco tra tutti i file validi che contengono la sottostringa
    for k = 1:length(extensions)
        files = dir(fullfile(folderPath, extensions{k}));
        for i = 1:length(files)
            if contains(lower(files(i).name), lower(nome_img))
                fullImagePath = fullfile(folderPath, files(i).name);
                output = imread(fullImagePath);
                foundImage = true;
                break;
            end
        end
        if foundImage
            break;
        end
    end
end

if ~foundImage
    error('Nessuna immagine trovata nella cartella %s con nome contenente "%s"', folderPath, nome_img);
end

end
