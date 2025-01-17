function [C] = genera_iride(EyeInfo, m, n)

% carichiamo il contorno dell'iride
Icy = EyeInfo.IrisInfo.CxIris;
Icx = EyeInfo.IrisInfo.CyIris;
Ir  = EyeInfo.IrisInfo.RIris;

% carichiamo il contorno della pupilla
Pcy = EyeInfo.PupilInfo.CxPupil;
Pcx = EyeInfo.PupilInfo.CyPupil;
Pr  = EyeInfo.PupilInfo.RPupil;

if(Icx+Icy+Ir==0)
    Icx = round(m/2);
    Icy = round(n/2);
    Ir  =  0.6*sqrt(Icx*Icx + Icy*Icy);
end

if(Pcx+Pcy+Pr==0)
    Pcx = Icx;
    Pcy = Icy;
    Pr  = 0.2*Ir;
end

C = zeros(m, n);
D = zeros(m, n);

% disegnamo l'iride
a = [1 0 1 0 0 0];
a(4) = -2*Icx;
a(5) = -2*Icy;
a(6) = Icx*Icx + Icy*Icy - Ir*Ir;

[X, Y] = drawellip(a,0,0, 4*pi*Ir);

X = round(X);
Y = round(Y);

for i=1:4*pi*Ir
    x = max(1,min(X(i), size(D,1)));
    y = max(1,min(Y(i), size(D,2)));
        
    C(x, y)=1;
end


C = 1-imfill(C);

% disegnamo la pupilla
a = [1 0 1 0 0 0];
a(4) = -2*Pcx;
a(5) = -2*Pcy;
a(6) = Pcx*Pcx + Pcy*Pcy - Pr*Pr;

[X, Y] = drawellip(a,0,0, 4*pi*Pr);

X = round(X);
Y = round(Y);

for i=1:4*pi*Pr
    x = max(1,min(X(i), size(D,1)));
    y = max(1,min(Y(i), size(D,2)));
        
    D(x, y)=1;
end

D = imfill(D);

C = 255*(C(1:m, 1:n)+D(1:m, 1:n));
