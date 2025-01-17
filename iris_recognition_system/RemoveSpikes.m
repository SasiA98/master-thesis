function [OutputImage] = RemoveSpikes(InputImage, stp)
   
    InputImage = rescale(double(InputImage));
    
    
    % Inizializza la matrice W
    W = zeros(size(InputImage));
    
    % Calcola le dimensioni dell'immagine
    [rows, cols] = size(InputImage);
    
    % Padding dell'immagine con bordi replicati per gestire gli intorni
    padSize = floor(stp/2);
    paddedImage = padarray(InputImage, [padSize padSize], 'replicate');
    
    % Per ogni pixel dell'immagine
    for i = 1:rows
        for j = 1:cols
            % Estrai l'intorno stp x stp
            localWindow = paddedImage(i:i+stp-1, j:j+stp-1);
            
            % Calcola la differenza tra il valore massimo e minimo nell'intorno
            W(i,j) = max(localWindow(:)) - min(localWindow(:));
        end
    end
    
    

    % Trova i pixel dove W è maggiore di 0.9 * max(W(:))
    spikeW = max(W(:))-W;

    % Crea l'immagine di output impostando a zero i pixel spike
    OutputImage = InputImage.*spikeW;
    
    % Converti l'immagine di output a uint8 se l'immagine in input era uint8
    OutputImage = uint8(rescale(OutputImage) .* 255);
    
end





