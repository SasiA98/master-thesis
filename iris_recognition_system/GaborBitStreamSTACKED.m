function [Vfeat, RGBIrisImage] = GaborBitStreamSTACKED(A, IrisInfo, PupilInfo)

A = double(A);

nscales=1; minWaveLength=24; mult=1;
% not applicable if using nscales = 1
sigmaOnf=0.5;

%normalisation parameters
radial_res = 64;
angular_res = 240; % with these settings a 9600 bit iris template is % created

% 
% Pcx = PupilInfo.CxPupil;
% Pcy = PupilInfo.CyPupil;
% Pr  = PupilInfo.RPupil;
% Icx = IrisInfo.CxIris;
% Icy = IrisInfo.CyIris;
% Ir  = IrisInfo.RIris;


% AR = A(:,:,1);
% AG = A(:,:,2);
% AB = A(:,:,3);

% % % [AR] = AdjustGray(AR);
% % % [AG] = AdjustGray(AG);
% % % [AB] = AdjustGray(AB);

% [AR, polar_noise] = normaliseiris(AR, Icx, Icy, Ir, Pcx, Pcy, Pr, radial_res, angular_res);
% [AG, polar_noise] = normaliseiris(AG, Icx, Icy, Ir, Pcx, Pcy, Pr, radial_res, angular_res);
% [AB, polar_noise] = normaliseiris(AB, Icx, Icy, Ir, Pcx, Pcy, Pr, radial_res, angular_res);

%  kernel = [-0.3078   -0.3844   -0.3078
%     0.8754    1.0932    0.8754
%    -0.3078   -0.3844   -0.3078];

[PolarImage] = PolarizeIris(A, IrisInfo, PupilInfo, angular_res, radial_res);

% PolarImage = imfilter(PolarImage, kernel, 'same');
PolarImage = double(PolarImage);
AR = PolarImage(:,:,1);
AG = PolarImage(:,:,2);
AB = PolarImage(:,:,3);

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


RGBIrisImage = zeros(size(AR,1), size(AR,2));
RGBIrisImage(:,:,1) = floor(255*rescale(AR));
RGBIrisImage(:,:,2) = floor(255*rescale(AG));
RGBIrisImage(:,:,3) = floor(255*rescale(AB));

[TR, mask] = encode(AR, zeros(radial_res, angular_res), nscales, minWaveLength, mult, sigmaOnf);
[TG, mask] = encode(AG, zeros(radial_res, angular_res), nscales, minWaveLength, mult, sigmaOnf);
[TB, mask] = encode(AB, zeros(radial_res, angular_res), nscales, minWaveLength, mult, sigmaOnf);

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
