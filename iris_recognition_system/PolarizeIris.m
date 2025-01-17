function [PolarImage] = PolarizeIris(IrisImage, IrisInfo, PupilInfo, W, H)
% [PolarImage] = RemapIris(IrisImage, IrisInfo, PupilInfo, IR, PR, W, H)
%
% Inputs:
%   IrisImage - L'immagine dell'iride RGB
%   IrisInfo  - struct con i campi:
%                 CxIris: coordinata x del centro dell'iride
%                 CyIris: coordinata y del centro dell'iride
%                 RIris: raggio dell'iride
%   PupilInfo - struct con i campi:
%                 CxPupil: coordinata x del centro della pupilla
%                 CyPupil: coordinata y del centro della pupilla
%                 RPupil: raggio della pupilla
%   IR        - raggio dell'iride
%   PR        - raggio della pupilla
%   W, H      - Larghezza e Altezza dell'immagine polarizzata in output
%
% Outputs:
%   PolarImage - Immagine dell'iride polarizzata

% Preallocazione per efficienza
PolarImage = zeros(H, W, 3, 'uint8');  % assumendo che IrisImage sia uint8

alpha = linspace(0, 2*pi, W); % spazio angolare

for i = 1:W
    % Calcola le coordinate dei punti sulla circonferenza della pupilla e dell'iride
    xPupil = PupilInfo.CxPupil + PupilInfo.RPupil * cos(alpha(i));
    yPupil = PupilInfo.CyPupil + PupilInfo.RPupil * sin(alpha(i));
    xIris = IrisInfo.CxIris + IrisInfo.RIris * cos(alpha(i));
    yIris = IrisInfo.CyIris + IrisInfo.RIris * sin(alpha(i));
    
    % Calcola H punti lungo il segmento [pi, pj]
    xLine = linspace(xPupil, xIris, H);
    yLine = linspace(yPupil, yIris, H);
    
    for j = 1:H
        % Verifica se le coordinate sono dentro i limiti dell'immagine
        if xLine(j) >= 1 && xLine(j) <= size(IrisImage, 2) && yLine(j) >= 1 && yLine(j) <= size(IrisImage, 1)
            % Assegna il colore del punto corrispondente all'immagine polarizzata
            PolarImage(j, i, :) = IrisImage(round(yLine(j)), round(xLine(j)), :);
        end
    end
end

end