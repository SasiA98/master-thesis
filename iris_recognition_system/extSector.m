

function imgSector = extSector(imgPar, xCenter, yCenter, rMin, rMax, alphaStart, alphaWidth, rStep, alphaStep)
    % Inizializza le variabili
    alphaStop = alphaStart + alphaWidth;
    rArray = rMin:rStep:rMax;
    alphaArray = alphaStart:alphaStep:alphaStop;
    
    % Calcola le dimensioni dell'output
    rLength = numel(rArray);
    cLength = numel(alphaArray);
    
    % Prealloca la matrice imgSector
    imgSector = zeros(rLength, cLength, size(imgPar, 3), 'like', imgPar);
    
    cRes = 0;
    
    % Vettorizzazione degli angoli
    for alpha = alphaArray
        c = cos(alpha);
        s = sin(alpha);
        
        cRes = cRes + 1;
        
        % Calcola le coordinate x e y per tutti i raggi simultaneamente
        xPoints = xCenter + int16(rArray * c);
        yPoints = yCenter - int16(rArray * s);
        
        % Trova gli indici validi
        validIdx = yPoints > 0 & xPoints > 0 & yPoints <= size(imgPar, 1) & xPoints <= size(imgPar, 2);
        
        % Assegna i valori
        imgSector(validIdx, cRes, :) = imgPar(sub2ind(size(imgPar), yPoints(validIdx), xPoints(validIdx)));
    end
end


% function imgSector=extSector(imgPar,xCenter,yCenter,rMin,rMax,alphaStart,alphaWidth,rStep,alphaStep)
% % extSector(imgPar,xCenter,yCenter,rMin,rMax) estrae un settore di centro
% % xCenter,yCenter e raggio minimo rMin e massimo r Max, angolo aOpen,
% % aOrient
% 
% rRes=0;cRes=0;
% alphaStop = alphaStart+alphaWidth;
% 
% imgSector = 0;
% 
% for alpha=alphaStart:alphaStep:alphaStop
%     
%     c = cos(alpha);
%     s = sin(alpha);
%     
%     cRes=cRes+1;
%     rRes=0;
% 
%     for rProg=rMin:rStep:rMax
%         
%         rRes=rRes+1;
%  
%         xPoint = xCenter+int16(rProg*c);
%         yPoint = yCenter-int16(rProg*s);
%       
%         if(yPoint>0 && xPoint>0 && yPoint<size(imgPar,1) && xPoint<size(imgPar,2))
%             imgSector(rRes,cRes,:)=imgPar(yPoint,xPoint,:);
%         end
%     
%     end
%     
% end




