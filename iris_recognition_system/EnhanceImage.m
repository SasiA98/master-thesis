function [EnhancedImage] = EnhanceImage(GrayImage)

    GrayImage = rescale(double(GrayImage));

    % Applica il filtro di Sobel per il rilevamento dei bordi
    SobelHorizontal = [-1 -2 -1; 0 0 0; 1 2 1];
    SobelVertical = [-1 0 1; -2 0 2; -1 0 1];
    
    EdgeImageHorizontal = imfilter(GrayImage, SobelHorizontal);
    EdgeImageVertical = imfilter(GrayImage, SobelVertical);
    
    % Combina le immagini dei bordi orizzontali e verticali
    EdgeImage = sqrt(EdgeImageHorizontal.^2 + EdgeImageVertical.^2);
    
    % Combina l'immagine dei bordi con l'immagine originale per ottenere una versione enfatizzata
    EnhancedImage = 0.7*GrayImage + 0.3*rescale(EdgeImage);
    
    
    EnhancedImage = uint8(rescale(EnhancedImage) .* 255);
end