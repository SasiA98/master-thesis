function [CorrectedImage] = GaussHistCut(Image)
    % Controllo se l'immagine è a colori (3 canali) o in scala di grigi
    [rows, cols, channels] = size(Image);
    
    if channels == 3  % Immagine RGB
        CorrectedImage = zeros(size(Image), 'uint8');  % Preallocazione
        
        % Applica il procedimento separatamente sui singoli canali
        for ch = 1:channels
            CorrectedImage(:,:,ch) = ProcessSingleChannel(Image(:,:,ch));
        end
    else  % Immagine in scala di grigi
        CorrectedImage = ProcessSingleChannel(Image);
    end
end

function [ProcessedChannel] = ProcessSingleChannel(Channel)
    % Calcola l'istogramma dei toni di grigio
    h = imhist(Channel);
    
    % Trova i parametri (media e deviazione standard) della gaussiana
    % che meglio approssima l'istogramma
    pixel_values = 0:255;
    weighted_sum = sum(pixel_values .* h');
    total_pixels = sum(h);
    mean_val = weighted_sum / total_pixels;
    variance = sum(((pixel_values - mean_val) .^ 2) .* h') / total_pixels;
    std_dev = sqrt(variance);
    
    % Calcola il valore della gaussiana per ogni tono di grigio
    gaussian_vals = (1/(std_dev*sqrt(2*pi))) * exp(-0.5*((pixel_values - mean_val)/std_dev).^2);
    
    % Soglia per determinare se un tono di grigio deve essere considerato
    threshold = max(gaussian_vals) * 0.1;  % Ad esempio, il 10% del massimo
    
    % Individua i toni di grigio da eliminare
    to_eliminate = gaussian_vals < threshold;
    
    % Elimina (metti a zero) i toni di grigio nella immagine di input
    ProcessedChannel = Channel;
    for i = 1:length(to_eliminate)
        if to_eliminate(i)
            ProcessedChannel(Channel == i-1) = mean_val+std_dev;
        end
    end
end