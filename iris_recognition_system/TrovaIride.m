% %  ---------------------------------------------------------------------  %
% % | Funzione per la localizzazione dell'iride                           | %
% % | cartesiane a coordinate polari.                                     | %
% %  ---------------------------------------------------------------------  %
% 
function [Radius, S] = TrovaIride(Iride, rpupil)

% Recuperiamo la regione contenente l'immagine dell'iride
H = Iride;

dime = size(H);


% creiamo una matrice delle stesse dimensioni dell'immagine di partenza, a
% meno di una unit� in verticale. Essa serve a calcolare il gradiente
% verticale
Dy = zeros(1, dime(1));

% Creiamo i punti di controllo che rappresenteranno la frontiera del limbo
S = zeros(1, dime(2));

% Applichiamo un appiattimento del contrasto attraverso il mediano.
% facciamo scorrere in orizzontale una finestra di 1x16 pixel e sostituiamo
% la posizione centrale con il mediano di tale regione.
for i=1:dime(1)
    for j=1:dime(2)-16
        H(i,j) = median(Iride(i, j:j+16));
    end
end

% Calcoliamo il gradiente verticale dell'immagine sottraendo al pixel in posizione
% j-4 il pixel in posizione j+4. Il Punto con il valore massimo positivo
% viene inserito in S come punto di frontiera


if(rpupil/dime(1)>0.1)
    rp = rpupil;
else
    rp = round(1.2*rpupil);
end

if(dime(1)-rp <=4 || dime(1)-rp+4 > dime(1))
    rp = dime(1) - 5;
end

for i=1:dime(2)
    %for j=round(dime(1)-1.2*Iris.rmin):-1:6
    for j=dime(1) - rp:-1:5
        Dy(j) = H(j-4, i)*(H(j-4, i) - H(j+4, i));
    end      
    
    S(i) = max(find(Dy == max(Dy)));

end

% Normalizziamo i valori di Radius1 e Radius2 in modo da poter estrarre in
% seguito la regione dell'iride dall'immagine originale. In altre parole,
% la matrice Dy � stata ottenuta sull'immagine originale in cui la parte
% inferiore � stata eliminata (moltiplicazione per 0.9 < 1). I valori dei
% raggi devono quindi essere riproporzionati in modo da corrispondere alle
% posizioni corrette sull'immagine originale (divisione per 0.9) essendo
% essi calcolati come sottrazione fra la riga inferiore dell'immagine
% (linearizazione del centro della pupilla) ed il valore (Radius1 o
% Radius2) precedentemente calcolato.

S = dime(1) - round(double(S));

% H = zeros(1, max(S));
% for i=1:max(S)
%     H(i) = sum(S == i);
% end
% Radius2 = max(find(H==max(H)));

Radius = median(S);

ERR = abs(S - Radius)/max(abs(S - Radius));

incorrect = find(ERR > 0.2);
S(incorrect) = Radius;
Radius = median(S);