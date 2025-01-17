function [Vfeat] = DaugmanFeatureExtractor(A, approach, verbose)

nscales=1; minWaveLength=24; mult=1;
% not applicable if using nscales = 1
sigmaOnf=0.5;

%normalisation parameters
radial_res = 64;
angular_res = 240; % with these settings a 9600 bit iris template is % created


if approach == 0 || approach == 2 

    if approach == 0            % from iris images (task1)
        PolarImage = A;
    else                        % from normalized iris images (task2, but "deprecated")
        PolarImage = imread(A); 
    end 

    PolarImage = double(PolarImage);
    
    if length(size(PolarImage))==2
        AR = PolarImage(:,:);
        AG = PolarImage(:,:);
        AB = PolarImage(:,:);
        
    elseif length(size(PolarImage))==3
        AR = PolarImage(:,:,1);
        AG = PolarImage(:,:,2);
        AB = PolarImage(:,:,3);
    end
    
    
    [AR] = double(GaussHistCut(uint8(AR)));
    [AG] = double(GaussHistCut(uint8(AG)));
    [AB] = double(GaussHistCut(uint8(AB)));
    
    mad = median(abs(AR(:)-median(AR(:))));
    AR = (AR-median(AR(:)))/mad;
    AR = rescale(AR);
    mad = median(abs(AG(:)-median(AG(:))));
    AG = (AG-median(AG(:)))/mad;
    AG = rescale(AG);
    mad = median(abs(AB(:)-median(AB(:))));
    AB = (AB-median(AB(:)))/mad;
    AB = rescale(AB);
    
    AR(isnan(AR))=0;
    AR(isinf(AR))=0;
    AG(isnan(AG))=0;
    AG(isinf(AG))=0;
    AB(isnan(AB))=0;
    AB(isinf(AB))=0;
    
    immm = zeros(size(PolarImage));
    immm(:,:,1) = AR;
    immm(:,:,2) = AG;
    immm(:,:,3) = AB;
    
    if verbose > 0
        mean_norm = mean(immm(:));
        disp(mean_norm);
        mean_norm = std(immm(:));
        disp(mean_norm);
    end
    
    [TR, mask] = encode(AR, zeros(radial_res, angular_res), nscales, minWaveLength, mult, sigmaOnf);
    [TG, mask] = encode(AG, zeros(radial_res, angular_res), nscales, minWaveLength, mult, sigmaOnf);
    [TB, mask] = encode(AB, zeros(radial_res, angular_res), nscales, minWaveLength, mult, sigmaOnf);
    
    if verbose > 0
        NewRGBIrisImage = zeros(size(PolarImage));
        
        for i=1:(angular_res-1)
            NewRGBIrisImage(:,i,1) = bin2dec(strcat(num2str(TR(:,(i*2)-1)), num2str(TR(:,(i*2)))));
            NewRGBIrisImage(:,i,2) = bin2dec(strcat(num2str(TG(:,(i*2)-1)), num2str(TG(:,(i*2)))));
            NewRGBIrisImage(:,i,3) = bin2dec(strcat(num2str(TB(:,(i*2)-1)), num2str(TB(:,(i*2)))));
        end
    
        mean_image_feature = mean(NewRGBIrisImage(:));
        disp(mean_image_feature);
        mean_image_feature = std(NewRGBIrisImage(:));
        disp(mean_image_feature);
    
        % Display the RGB image
        imshow(NewRGBIrisImage);
    end

elseif approach == 1 % from feature images (task 2 or 3)

    comp_T = load(A).matrix;
    comp_T = uint8(comp_T);

    [rows, cols, channels] = size(comp_T);

    T = zeros(radial_res, angular_res*2, channels);
    T = uint8(T);
    
    for k=1:channels
        for i=1:radial_res
            for j=1:angular_res
                if comp_T(i,j,k) == 0
                    T(i,(j*2)-1,k) = 0;
                    T(i,(j*2),k) = 0;
    
                elseif comp_T(i,j,k) == 1
                    T(i,(j*2)-1,k) = 0;
                    T(i,(j*2),k) = 1;
    
                elseif comp_T(i,j,k) == 2
                    T(i,(j*2)-1,k) = 1;
                    T(i,(j*2),k) = 0;
    
                elseif comp_T(i,j,k) == 3
                    T(i,(j*2)-1,k) = 1;
                    T(i,(j*2),k) = 1;
                end
            end
        end
    end

    if channels ==3
        TR = double(T(:,:,1));
        TG = double(T(:,:,2));
        TB = double(T(:,:,3));
    else 
        TR = double(T);
        TG = double(T);
        TB = double(T);  
    end

end

% ------------------------------------------------------------ %
T2 = find((TR(:)' + TG(:)' + TB(:)')==3);
T1 = find((TR(:)' + TG(:)' + TB(:)')==0);
T=0*TR(:)';
T(T2)=2;
T(T1)=1;

cnt = 1;
Vfeat = zeros(1, 1+ceil(length(T)/8));
for i=1:length(T)
    p=rem(i,8);
    if(p==0)
        cnt = cnt+1;
    end
    Vfeat(cnt) = Vfeat(cnt) + T(i)*3^p;
end

Vfeat = Vfeat(1:ceil(length(T)/8));

