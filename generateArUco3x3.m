function generateArUco3x3_512()
    % Definizione delle variabili
    markerSize = 300; % Dimensione del marker in pixel
    borderSize = 100; % Dimensione della cornice bianca in pixel (100 pixel per una cornice spessa)
    outputDirPNG = 'ArUcoMarkers_3x3_512'; % Directory per salvare i marker in formato PNG
  %  outputDirSVG = 'ArUcoMarkers_3x3_512_svg'; % Directory per salvare i marker in formato SVG

    % Crea le directory se non esistono
    if ~exist(outputDirPNG, 'dir')
        mkdir(outputDirPNG);
    end
    % if ~exist(outputDirSVG, 'dir')
    %     mkdir(outputDirSVG);
    % end

    % Crea e salva i marker ArUco per il dizionario 3x3 con 512 marcatori
    for markerID = 0:511  % Per tutti i marker 0-511
        % Crea il marker ArUco
        markerImage = aruco_draw_marker_3x3(markerID, markerSize, borderSize);
        
        % Salva l'immagine del marker in formato PNG
        filenamePNG = fullfile(outputDirPNG, sprintf('aruco_marker_%d.png', markerID));
        imwrite(markerImage, filenamePNG);
        
        % % Crea il marker ArUco in formato vettoriale SVG
        % filenameSVG = fullfile(outputDirSVG, sprintf('aruco_marker_%d.svg', markerID));
        % aruco_draw_marker_svg(markerID, markerSize, borderSize, filenameSVG);
        
        % Mostra un messaggio di conferma
        fprintf('Marker %d salvato in PNG: %s\n', markerID, filenamePNG);
        % fprintf('Marker %d salvato in SVG: %s\n', markerID, filenameSVG);
    end
end

function markerImage = aruco_draw_marker_3x3(markerID, markerSize, borderSize)
    % Questa funzione genera un marker ArUco 3x3 specificato da markerID e di dimensione markerSize con una cornice bianca
    
    % Crea una matrice binaria per il marker
    pattern = aruco_marker_pattern_3x3(markerID);
    
    % Dimensioni dell'immagine finale
    finalSize = markerSize + 2 * borderSize;

    % Crea una matrice nera per il marker (se  deve essere bianca
    % sostituire a 0 il valore 255
    markerImage = 0 * ones(finalSize, finalSize);

    % Ridimensiona il pattern per includere la cornice
    scaledPattern = imresize(pattern, [markerSize, markerSize], 'nearest');
    
    % Inserisce il pattern al centro dell'immagine
    markerImage(borderSize+1:borderSize+markerSize, borderSize+1:borderSize+markerSize) = scaledPattern * 255;

    % Converti in immagine nera e bianca
    markerImage = uint8(markerImage);
end

function pattern = aruco_marker_pattern_3x3(markerID)
    % Definisce i pattern per i marker ArUco per il dizionario 3x3 con 512 marcatori
    % Il dizionario 3x3 con 512 marcatori usa una matrice di 3x3 per ogni marker
    
    % Costruzione del marker pattern usando la rappresentazione binaria del markerID
    % Convertiamo l'ID in una matrice di bit
    bits = id2bitArray(markerID, 3); % Convertiamo l'ID in una matrice di bit
    bits = reshape(bits, [3, 3])';

    % Crea una matrice binaria per il pattern del marker
    pattern = double(bits);
end

function bits = id2bitArray(id, nBits)
    % Converte un ID in una matrice di bit con nBits x nBits bit
    bits = bitget(id, nBits^2:-1:1);
    bits = double(bits);
end

% function aruco_draw_marker_svg(markerID, markerSize, borderSize, filename)
%     % Questa funzione genera un marker ArUco 3x3 specificato da markerID in formato SVG
% 
%     % Crea una matrice binaria per il marker
%     pattern = aruco_marker_pattern_3x3(markerID);
% 
%     % Ridimensiona il pattern per includere la cornice
%     scaledPattern = imresize(pattern, [markerSize, markerSize], 'nearest');
% 
%     % Crea una figura per l'SVG
%     fig = figure('Visible', 'off');
%     hold on;
% 
%     % Disegna il pattern del marker
%     for i = 1:3
%         for j = 1:3
%             if scaledPattern(i, j) == 1
%                 % Disegna il quadrato nero per il bit "1"
%                 fill([j-1, j, j, j-1]*markerSize, [i-1, i-1, i, i]*markerSize, 'k', 'EdgeColor', 'none');
%             end
%         end
%     end
% 
%     % Imposta le proprietà della figura
%     axis equal;
%     axis off;
%     set(gca, 'Color', 'w'); % Imposta lo sfondo bianco
% 
%     % Salva la figura come file SVG
%     saveas(fig, filename, 'svg');
% 
%     % Chiude la figura
%     close(fig);
% end