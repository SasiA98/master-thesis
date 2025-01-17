function Feat = FractalFeatures(Image)

    Feat = [];
    % Verifica se l'immagine è in scala di grigi o RGB
    [~,~,numChannels] = size(Image);
    if numChannels > 1 % Se RGB, applica la funzione a ciascun canale
        % for c = 1:numChannels
        %     Feat = [Feat, TextureFeaturesPerChannel(Image(:,:,c))];
        % end
        Feat = TextureFeaturesPerChannel(rgb2gray(Image));
    else % Se scala di grigi, procedi direttamente
        Feat = TextureFeaturesPerChannel(Image);
    end
    Feat = Feat(setdiff(1:length(Feat), 1:3:length(Feat)));
end


function Texels = TextureFeaturesPerChannel(Channel)

    % Dimensioni dell'immagine
    [height, width] = size(Channel);

    % Dimensione delle celle di output
    outputHeight = floor(height / 16);
    outputWidth = floor(width / 16);
    
    % Preallocazione per l'immagine di output
    Texels = [];
    
    % Iterazione attraverso l'immagine 8x8 blocchi
    for i = 1:16:height-16
        for j = 1:16:width-16
            
            % Estrazione del blocco 8x8
            block = Channel(i:i+16, j:j+16);
            
            % Applica la Trasformata Coseno Discreta (DCT) al blocco
           Texels = [Texels, sfta( block, 5 )];
        end
    end
    
end