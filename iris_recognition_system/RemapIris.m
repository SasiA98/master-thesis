function [B] = RemapIris(A, IrisInfo, PupilInfo, IR, PR)

B = zeros(2*IR, 2*IR, 3);

Ox = IR;
Oy = IR;

Icx = IrisInfo.CxIris;
Icy = IrisInfo.CyIris;
Ir  = IrisInfo.RIris;

Pcx = PupilInfo.CxPupil;
Pcy = PupilInfo.CyPupil;
Pr  = PupilInfo.RPupil;

for alpha = 0:1/IR:2*pi
    for ro = PR:0.5:IR
        tx = round(Ox + ro*cos(alpha));
        ty = round(Oy + ro*sin(alpha));
        
        D = ro - PR;
        dr = D/(IR-PR);
        
        P1x = Pcx + Pr*cos(alpha);
        P1y = Pcy + Pr*sin(alpha);
        P2x = Icx + Ir*cos(alpha);
        P2y = Icy + Ir*sin(alpha);
        
        Px = round(dr*P2x + (1-dr)*P1x);
        Py = round(dr*P2y + (1-dr)*P1y);
        
%         [Px, Py, tx, ty]
        if(Px>0 && Py>0 && Px<size(A,1) && Py<size(A,2) && tx>0 && ty>0 && ty<size(B,1) && tx<size(B,2))
            try
                B(ty, tx, :) = A(Py, Px, :);
            end
        end
    end
end