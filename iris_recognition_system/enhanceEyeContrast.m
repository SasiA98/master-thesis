function enhanced_eye = enhanceEyeContrast(eye_image)

    % Converti l'immagine in scala di grigi se è a colori
    if size(eye_image, 3) == 3
        eye_image = rgb2gray(eye_image);
    end
    
    % Identifica le ROI (pupilla e iride) utilizzando un semplice thresholding
    threshold_value = graythresh(eye_image);
    binary_eye = imbinarize(eye_image, threshold_value);
    
    % Esegui operazioni morfologiche per rimuovere il rumore
    processed_eye = imopen(binary_eye, strel('disk', 5));
    
    % Etichetta le regioni connesse
    [labeled_eye, num_objects] = bwlabel(processed_eye);
    
    % Inizializza l'immagine di output
    enhanced_eye = eye_image;
    
    % Applica il miglioramento del contrasto solo alle ROI
    for i = 1:num_objects
        % Estrai la regione i-esima
        region = (labeled_eye == i);
        
        % Estrai la sotto-immagine corrispondente alla regione
        sub_image = eye_image(region);
        
        % Migliora il contrasto della sotto-immagine (ad es. equalizzazione dell'istogramma)
        sub_image_enhanced = histeq(sub_image);
        
        % Sostituisci la sotto-immagine migliorata nell'immagine originale
        enhanced_eye(region) = sub_image_enhanced;
    end
    
end