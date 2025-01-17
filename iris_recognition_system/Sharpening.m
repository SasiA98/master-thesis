function [SharpenImage] = Sharpening(Image, stp)
    % Controllo se l'immagine è a colori (3 canali) o in scala di grigi
    [rows, cols, channels] = size(Image);
    
    if channels == 3  % Immagine RGB
        SharpenImage = zeros(size(Image), 'uint8');  % Preallocazione
        
        % Applica il procedimento separatamente sui singoli canali
        for ch = 1:channels
            SharpenImage(:,:,ch) = SharpenChannelPatchwise(Image(:,:,ch), stp);
        end
    else  % Immagine in scala di grigi
        SharpenImage = SharpenChannelPatchwise(Image, stp);
    end
end

function [SharpenedChannel] = SharpenChannelPatchwise(Channel, stp)
    [rows, cols] = size(Channel);
    
    % Padding dell'immagine per facilitare la divisione in patch
    paddedChannel = padarray(Channel, [mod(stp - mod(rows, stp), stp), mod(stp - mod(cols, stp), stp)], 'post');
    
    [paddedRows, paddedCols] = size(paddedChannel);
    SharpenedChannel = zeros(paddedRows, paddedCols);
    
    allGM = [];
    
    % Calcolo della Gradient Magnitude per ogni patch e raccolta di tutte le GM
    for i = 1:stp:paddedRows
        for j = 1:stp:paddedCols
            patch = paddedChannel(i:i+stp-1, j:j+stp-1);
            [Gmag,~] = imgradient(patch);
            allGM = [allGM; Gmag(:)];
        end
    end
    
    % Calcolo media e varianza delle GM
    meanGM = mean(allGM);
    varGM = var(allGM);
    
    % Definizione del kernel di sharpening
    kernel = [-0.3078   -0.3844   -0.3078
    0.8754    1.0932    0.8754
   -0.3078   -0.3844   -0.3078];
    
    % Applicazione dello sharpening in modo condizionale
    for i = 1:stp:paddedRows
        for j = 1:stp:paddedCols
            patch = paddedChannel(i:i+stp-1, j:j+stp-1);
            [Gmag,~] = imgradient(patch);
            
            if mean(Gmag(:)) < (meanGM - 0*varGM)
                'si'
                SharpenedChannel(i:i+stp-1, j:j+stp-1) = 0.75*patch + 0.25*imfilter(patch, kernel, 'same');
            else
                SharpenedChannel(i:i+stp-1, j:j+stp-1) = patch;
            end
        end
    end
    
    % Ritaglio dell'immagine sharpened per portarla alle dimensioni originali
    SharpenedChannel = SharpenedChannel(1:rows, 1:cols);
end