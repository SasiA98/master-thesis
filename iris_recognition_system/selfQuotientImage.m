function outputImage = selfQuotientImage(inputImage)
    % Verifica che l'immagine di ingresso sia in scala di grigi
    if size(inputImage, 3) == 3
        inputImage = rgb2gray(inputImage);
    end

    inputImage(inputImage(:)>0.9*max(inputImage(:)))=0;

    % Converte l'immagine in double per una precisione maggiore durante la divisione
    inputImage = double(inputImage);


    % Crea un filtro gaussiano con deviazione standard specificata
    gaussianFilter = fspecial('gaussian', [32 32], 8);
    
    
    % Applica il filtro gaussiano per sfocare l'immagine
    blurredImage = imfilter(inputImage, gaussianFilter, 'replicate');


    % Calcola la Self-Quotient Image
    sqi = inputImage ./ (blurredImage + 1);  % Aggiunge 1 per evitare la divisione per zero

    % Rimappa l'immagine nel range [0, 255]
    sqi = (sqi - min(sqi(:))) / (max(sqi(:)) - min(sqi(:))) * 255;
    
    % Converte l'immagine in uint8
%     sqi = uint8(sqi);

    hf = fspecial('prewitt');
    ContourImage = abs(imfilter(sqi, hf, 'replicate'));
    ContourImage = ContourImage/max(ContourImage(:));
    sqi = uint8(255*rescale(sqi - ContourImage));


    outputImage = zeros(size(inputImage));
    for i=min(sqi(:)):max(sqi(:))
        t = find(sqi(:)==i);
        outputImage(t) = mean(inputImage(t));
    end

outputImage = uint8(255*(0.7*rescale(outputImage)+0.3*rescale(inputImage)));