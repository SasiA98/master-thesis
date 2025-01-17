%  ---------------------------------------------------------------------  %
% | Funzione per la trasformazione di una immagine da coordinate        | %
% | cartesiane a coordinate polari.                                     | %
%  ---------------------------------------------------------------------  %

function B = Cartesian2Polar(A, C, dim, verbose)

% dim lo si fissa a 360 (gradi) poich� gli angoli da radianti vengono convertiti in gradi
% questo ci risolve il problema di dover scegliere la risoluzione ;)


% Calcoliamo le dimensioni dell'immagine di input
n = size(A);

% Recuperiamo le coordinate del centro della pupilla
xc = C(1);
yc = C(2);

% Calcoliamo il raggio massimo, come la distanza del centro dall'angolo
% superiore sinistro dell'immagine
P1 = [0 0];
P2 = [0 size(A,2)];
P3 = [size(A,1) 0];
P4 = [size(A,1) size(A,2)];
d1 = round(sqrt((xc-P1(1))^2 + (yc-P1(2))^2));
d2 = round(sqrt((xc-P2(1))^2 + (yc-P2(2))^2));
d3 = round(sqrt((xc-P3(1))^2 + (yc-P3(2))^2));
d4 = round(sqrt((xc-P4(1))^2 + (yc-P4(2))^2));

roMax = max([d1 d2 d3 d4]);

% Questo valore rappresenta il minimo raggio a partire dal quale ci sono
% punti non assegnati nella linearizzazione. Inizialmente � impostato allo
% stesso valore di roMax. Esso verr� decrementato durante il processo di
% linearizzazione.
roMin = roMax;

% Creiamo una immagine nera delle dimensioni (dim, roMax)
B = zeros(dim, roMax);

% Per ciascun angolo e per ciascun raggio, recuperiamo il pixel
% corrispondente dall'immagine originale
for theta = 1:1:dim
    for ro = 1:1:roMax %ropupil:1:roMax
        
        % Trasformiamo l'angolo da radianti in gradi
        th = (theta*2*pi)/dim;
        th = th - pi;
        
        % Calcoliamo le coordinate cartesiane x e y corrispondenti
        x = round(ro*cos(th));
        y = round(ro*sin(th));
        
        % Trasliamo le coordinate rispetto al centro
        newx = xc + x;
        newy = yc + y;
       
       % Se le nuove coordinate non sforano, recuperiamo il pixel corrispondente in A    
       if(newx > 0   &   newy > 0 & newy < size(A,2) & newx < size(A,1))
           B(theta, ro) = A(newx, newy);
       else
           if (ro < roMin)
               roMin = ro;
           end
       end
        
    end
end

% Eliminiamo la parte contenente pixel non assegnati
%B = B(:, 1:min(roMax, 1.2*roMin));
%B = B(:, 1:min(roMax, roMin));

% ruotiamo l'immagine di 90 gradi considerando la trasposta
B = B';
B = flipud(B);

if (verbose)
    figure(1);
    subplot(3,3,4);
    imshow(uint8(B), []);
end