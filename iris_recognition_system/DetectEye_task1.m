function [VISRGBIrisImage, SYNRGBIrisImage] = DetectEye_task1(synthetic_filename, vis_filename, tipo, opts)

verbose = opts.verbose;
EyeInfo = struct;

% carichiamo l'immagine
A = imread(synthetic_filename);
Asynt_orig = A;
Avis_orig = imread(vis_filename);

Hres = size(A,1);
Wres = size(A,2);

% riduciamo le sue dimensioni ad una larghezza di max 500 pixel, per
% ridurre abbattere i tempi di segmentazione (commentare la riga, nel caso
% si voglia la risoluzione intera)
fc = 600/size(A,1);
A = imresize(uint8(A), 600/size(A,1), 'bicubic');

if(size(A,3)>1)
    Argb=A;
    Argb(:,:,1)=A(:,:,1);
    Argb(:,:,2)=A(:,:,2);
    Argb(:,:,3)=A(:,:,3);
else
    Argb = zeros(size(A,1), size(A,2), 3);
    Argb(:,:,1)=A;
    Argb(:,:,2)=A;
    Argb(:,:,3)=A;
end


% dimensione dell'immagine
dime = size(A); 

% se l'immagine � a colori, viene convertita in una immagine in toni di
% grigio
if size(size(A),2) == 3
    AC = rgb2gray(A);
else
    % creiamo una copia dell'immagine di input
    AC = A;
end

% Argb(:,:,1) = RemoveSpikes(Argb(:,:,1),7);
% Argb(:,:,2) = RemoveSpikes(Argb(:,:,2),7);
% Argb(:,:,3) = RemoveSpikes(Argb(:,:,3),7);

Anor(:,:,1) = selfQuotientImage(Argb(:,:,1));
Anor(:,:,2) = selfQuotientImage(Argb(:,:,2));
Anor(:,:,3) = selfQuotientImage(Argb(:,:,3));

Anor(:,:,1) = RemoveSpikes(Anor(:,:,1),7);
Anor(:,:,2) = RemoveSpikes(Anor(:,:,2),7);
Anor(:,:,3) = RemoveSpikes(Anor(:,:,3),7);

Anor(:,:,1) = EnhanceImage(Anor(:,:,1));
Anor(:,:,2) = EnhanceImage(Anor(:,:,2));
Anor(:,:,3) = EnhanceImage(Anor(:,:,3));
[A] = posterize(Anor,1000);
A=rgb2gray(A);


% se � attivata la modalit� 'verbose' mostriamo l'input ed il
% corrispondente filtrato
if (verbose)
    figure(1);
    clf;
    subplot(3,3,1);
    imshow(uint8(AC), []);

    subplot(3,3,2);
    imshow(uint8(A), []);
end


%  ---------------------------------------------------------------------------------  %
% | Applichiamo il filtro Canny all'immagine posterizzata con valori                | %
% | crescenti per il parametro della soglia [0.05, 0.10, 0.15, ..., 0.95]; (Slices) | %  
% | Per ciascuna Slice cerchiamo le componenti connesse.                            | %
% | Per ciascuna componente connessa calcoliamo l'ellisse che la approssima         | %
% | Selezioniamo solo le componenti connesse con ellissi la cui eccentricit� �      | %
% | vicina ad 1 (cerchio)                                                           | %
%  ---------------------------------------------------------------------------------  %

% Definiamo la struttura che conterr� le componenti selezionate in base
% all'eccentricit�
IrisComp = struct;

% Impostiamo il valore delle variabili utilizzate
NumComp = 0; % numero di componenti connesse selezionate (= 0)
cnt = 1;  % contatore per indicare il quadrante in cui disegnare (subplot)
nSlice = size(0.05:0.05:0.95,2); % numero di slice considerate
PlotRow = floor(sqrt(nSlice));  % numero di figure su una riga 
PlotCol = ceil(nSlice/PlotRow); % numero di figure su una colonna
CompDim = 100;   % numero minimo di pixel affinch� una componente connessa venga considerata
ECC = 0.3;  % valore di eccentricit� minimo affinch� una ellisse venga considerata

if(verbose > 2)
    figure(2);
    close(2);
end

%inizializziamo con una ellisse di default
% Aggiungiamo la componente alla struttura
IrisComp(1).n = 0;
IrisComp(1).X = 0;
IrisComp(1).Y = 0;
IrisComp(1).MinA = 0;
IrisComp(1).MajA = 0;
IrisComp(1).Cx = 0;
IrisComp(1).Cy = 0;
IrisComp(1).area = 0;
IrisComp(1).Para = [0 0 0 0 0 0];
IrisComp(1).ecc = 0;
IrisComp(1).Rank = 0;
IrisComp(1).rmin = 0;
IrisComp(1).rmax = 0;
IrisComp(1).Polar = 0;

            
% Elaboriamo le Slice, una alla volta (vecchio for i=0.05:0.05:0.95)
for i=0.05:0.05:0.5
    
    % Calcoliamo la Slice
    B = filtro_canny(A, i);


    % Calcoliamo la curvatura ed eliminiamo i punti a curvatura superiore
    % ad una certa soglia
    [L] = bwlabel(B>0);
    ncomp = max(max(L));

    C = B;
    
    for j=1:ncomp
        
        [Cx, Cy] = find(L==j);
    
        [Xout, Yout] = sortpixels(Cx,Cy);
        
        n = length(Xout);
    
        d = 4*round(log(n)/log(2));

        curva = calcolacurvatura(Xout, Yout, d);
    
        curva_med = curva;
        curva_med = medfilt2(curva, [1, 4]);
    
        Mn = find(curva>0.3);
        
        if(length(Mn)<2)
            continue;
        end
    
        [NewMn] = PrunePoints(Mn, Xout(Mn), Yout(Mn), 4);
    
        if(length(NewMn)<2)
            continue;
        end
         
        for k=1:length(Mn)
            C(Xout(Mn(k)), Yout(Mn(k))) = 0;
        end
    end

    B = C;
    
    if(verbose>2)
        figure(2);
        subplot(PlotRow, PlotCol,cnt);
        imshow(255*B, []);
        hold on;
    end
    
    % Calcoliamo le componenti connesse
    [L, ncomp] = bwlabeln(B);
    
    % Per ciascuna componente tranne il background (L==0) calcoliamo l'ellisse
    for k=1:ncomp
        
        % Recuperiamo i punti della componente k-esima
        [X, Y] = find(L==k); 

        
        % Contiamo quanti sono
        n = size(X, 1); 
    
        % Se sono meno di CompDim la componente � troppo piccola e viene
        % ignorata
        if(size(X, 1) > CompDim)
            
            try
                % calcoliamo i parametri dell'ellisse che approssima la
                % componente connessa
                %a = fitellipse(X,Y);
                %a = findcircle(X, Y);
                Par = CircleFitByTaubin(X, Y);
                a = [Par(1) Par(2) Par(3) Par(3) 0 0];
            
                
                % Ci assicuriamo che MajA sia l'asse maggiore e MinA quello minore
                MajA = max([a(4) a(3)]);
                MinA = min([a(4) a(3)]);
            
                % Calcoliamo l'eccentricit� dell'ellisse
                ecc = 1 - MinA/MajA;
            catch
                'errore nella determinazione della ellisse'
                ecc = 2;
            end
        else
            'numero di punti insufficiente';
            ecc = 2;
        end
              
        % Verifichiamo l'eccentricit� dell'ellisse e decidiamo se tenere o meno la
        % componente
        if ecc < ECC
            
            % Incrementiamo il numero di componenti nella struttura
            NumComp = NumComp + 1;
            
            % Aggiungiamo la componente alla struttura
            IrisComp(NumComp).n = n;
            IrisComp(NumComp).X = X;
            IrisComp(NumComp).Y = Y;
            IrisComp(NumComp).MinA = MinA;
            IrisComp(NumComp).MajA = MajA;
            IrisComp(NumComp).Cx = a(2);
            IrisComp(NumComp).Cy = a(1);
            IrisComp(NumComp).area = (MinA * MajA)/2;
            IrisComp(NumComp).Para = a;
            IrisComp(NumComp).ecc = ecc;
            IrisComp(NumComp).Rank = 0;
       
        end
        
        
        if(verbose>2 && ecc<=1)
            figure(2);
            subplot(PlotRow, PlotCol,cnt);
       
            if(size(X, 1) > CompDim)
                plot_ellipse(MajA, MinA, a(5), 0, [a(2) a(1)], 'r');
            end
        
        end
         
    end
   
        
     % Incrementiamo il contatore per i quadranti
     cnt = cnt + 1;
end

%  -----------------------------------------------------  %
% | Selezioniamo le ellissi sulla base dell'eccentricit� |%
%  -----------------------------------------------------  %


EllissiValide = 0;
% Cicliamo su tutte le ellissi selezionate
for h=1:NumComp 
    
        % Recuperiamo i parametri dell'ellisse corrente, e definiamo i
        % limiti del rettangolo che la comprende: [ xstr,xstp, ystr, ystp ]
        Para =IrisComp(h).Para;
        MajA = max([Para(4) Para(3)]);
        MinA = min([Para(4) Para(3)]);
        
        if( (Para(2)-MajA < 1)  || (Para(2)+MajA > dime(2)) || (Para(1)-MinA < 1) || (Para(1)+MinA > dime(1)))
            IrisComp(h).ecc = 1;
        end
            
        xstr = round(max([ Para(2)-MajA 1]));
        xstp = round(min([ Para(2)+MajA dime(2)]));
        ystr = round(max([ Para(1)-MinA 1]));
        ystp = round(min([ Para(1)+MinA dime(1)]));

        IrisComp(h).Rank = 0;
        
        IrisComp(h).rmin = (MajA+MinA)/2;
        
        if IrisComp(h).ecc < ECC && 2*MajA < min([dime(1) dime(2)])
            
           EllissiValide = EllissiValide + 1;
           
           % Assegnamo uno score [0 - ECC] in proporzione rispetto
           % all'eccentricit� (es.: eccentricit� 0.1, soglia ECC = 0.3
           % generano uno score di 0.3 - 0.1 = 0.2 )
           IrisComp(h).Rank = IrisComp(h).Rank + ECC - IrisComp(h).ecc;
           IrisComp(h).Ec = ECC - IrisComp(h).ecc;
           
           % Assegnamo uno score di 0.5 se l'area dell'ellisse �
           % maggiore di una soglia prefissata Th = (pi*(dime(1)^2 +
           % dime(2)*2))/1500) e il suo asse maggiore � contenuto interamente
           % nell'immagine. Queste soglie dipendono dalle dimensioni
           % 'dime' dell'immagine
           IrisComp(h).Rank = IrisComp(h).Rank + 0.5 * (IrisComp(h).area > (pi*(dime(1)^2 + dime(2)*2))/1500);
           IrisComp(h).Ar = 0.5 * (IrisComp(h).area > (pi*(dime(1)^2 + dime(2)*2))/1500);
           
           
           % Assegnamo uno score [0 - 1] uguale al rapporto fra il massimo
           % dell'istogramma e la somma di tutti gli elementi
           % dell'istogramma stesso. Se questo rapporto tende ad 1, la
           % regione � molto uniforme.
           H = imhist(uint8(AC(round(ystr:ystp), round(xstr:xstp))));
           H = mediano(double(H(1:254)), 8);
           IrisComp(h).Rank = IrisComp(h).Rank + max(H)/sum(H);
           %IrisComp(h).Rank = IrisComp(h).Rank + 1 - max(H)/255;
           IrisComp(h).Hi = max(H)/sum(H);
           
           [iso] = isolamento(A, round(IrisComp(h).Cx), round(IrisComp(h).Cy), MajA);
           IrisComp(h).Rank = IrisComp(h).Rank + iso;
           IrisComp(h).Is = iso;              
        end

end


if (EllissiValide == 0)
    Iris = 0;
    'Nessuna Ellisse Trovata';
    return;
end


 
% Selezioniamo l'ellisse con il maggior score
R = 0;
for h = 1:NumComp
    R(h) = IrisComp(h).Rank;
end
    

bestEllipse = min(find(R == max(R)));
Para = IrisComp(bestEllipse).Para;

 MajA = max([Para(4) Para(3)]);
 MinA = min([Para(4) Para(3)]);
 a = [MajA, MinA, Para(5), 0, Para(2), Para(1)];

% Disegnamo l'ellisse sull'immagine originale
if(verbose)
    figure(1);
    subplot(3,3,3);
    imshow(uint8(Argb), []);
    hold on;

    plot_ellipse(a(1), a(2), a(3), a(4), [a(5) a(6)], 'g');
    plot(a(5), a(6), 'r*');

end

% Restituiamo la struttura contenente le informazioni sull'ellisse trovata
Iris = IrisComp(bestEllipse);
Iris.Filtered = A;

Iris.Polar = Cartesian2Polar(uint8(A), round([Iris.Cy Iris.Cx]), 360, verbose);

CyPupil = Iris.Cy;
CxPupil = Iris.Cx;
rPupil = round(MajA);
Radius1 = rPupil;

[Radius2, S] = TrovaIride(Iris.Polar, round(1.2*MajA));

% Se la seguente condizione � verificata, l'intera iride � stata rilevata
% come pupilla
Iris.rmin = 1;
Iris.rmax = 2;

if(Radius1/Radius2 > 0.75 || Radius1/dime(1)>0.2)
    if(tipo==0)
        Radius2 = Radius1;
        Iris.Polar = extSector(AC, Iris.Cx, Iris.Cy, 1, Radius2,0, 2*pi, 1, 1/Radius2);
        [Radius1, Sp] = TrovaPupilla(Iris.Polar, Radius2);

        rPupil = Radius1;
    else
        Radius2 = Radius1;
        Radius1 = max(round(0.3*Radius1), 10);
        rPupil = Radius1;
        rIris = Radius2;
        Sp = ones(1,128)*Radius1;
    end
end

if (Radius2>Radius1 && Radius1 > 1 && Radius2>2)
    %[Iride] = EstraiIride(AC, round([Iris.Cy Iris.Cx]), Radius1, Radius2, verbose);
    Iris.Polar = extSector(AC, Iris.Cx, Iris.Cy, Radius1, Radius2,0, 2*pi, 1, 1/Radius2);
    Iris.rmin = Radius1;
    Iris.rmax = Radius2;
else
    Iride = zeros(100, 300);
end

X = 0;
Y = 0;
n = size(S,2);
for i=1:n
    ro = S(i);
%     theta = (i*2*pi)/n;
%     theta = theta - pi;
    theta = (i-1)*2*pi/(n-1) - pi;
    
    X(i) = Iris.Cy + ro*cos(theta);
    Y(i) = Iris.Cx + ro*sin(theta);
end

Ell = fitellipse(X,Y);


EyeInfo.PupilInfo.CxPupil = Iris.Cx/fc;
EyeInfo.PupilInfo.CyPupil = Iris.Cy/fc;
EyeInfo.PupilInfo.RPupil = rPupil/fc;

EyeInfo.IrisInfo.CxIris = Ell(2)/fc;
EyeInfo.IrisInfo.CyIris = Ell(1)/fc;
EyeInfo.IrisInfo.RIris = Radius2/fc;

dst = norm([EyeInfo.PupilInfo.CxPupil,EyeInfo.PupilInfo.CyPupil]-[EyeInfo.IrisInfo.CxIris,EyeInfo.IrisInfo.CyIris], 'fro');
if(abs(EyeInfo.PupilInfo.CxPupil-EyeInfo.IrisInfo.CxIris)>EyeInfo.IrisInfo.RIris || dst>EyeInfo.IrisInfo.RIris || EyeInfo.PupilInfo.RPupil>1/2*EyeInfo.IrisInfo.RIris)
    EyeInfo.PupilInfo.RPupil = round(1/3*EyeInfo.IrisInfo.RIris);
    EyeInfo.PupilInfo.CxPupil = EyeInfo.IrisInfo.CxIris;
    EyeInfo.PupilInfo.CyPupil = EyeInfo.IrisInfo.CyIris;
end

if(opts.verbose>2)
    figure(1002);
    imshow(uint8(Argb));
    hold on;
    plot_ellipse(EyeInfo.PupilInfo.RPupil, EyeInfo.PupilInfo.RPupil, 0, 0, [EyeInfo.PupilInfo.CxPupil EyeInfo.PupilInfo.CyPupil], 'r');
    plot(EyeInfo.PupilInfo.CyPupil, EyeInfo.PupilInfo.CxPupil, 'yo');
    plot_ellipse(EyeInfo.IrisInfo.RIris, EyeInfo.IrisInfo.RIris, 0, 0, [EyeInfo.IrisInfo.CxIris EyeInfo.IrisInfo.CyIris], 'g');
    plot(EyeInfo.PupilInfo.CyPupil, EyeInfo.PupilInfo.CxPupil, 'ms');
end

[C] = genera_iride(EyeInfo, Hres, Wres);
EyeInfo.Mask = C;

% EyeInfo.IrisImage = RemapIris(Argb, EyeInfo.IrisInfo, EyeInfo.PupilInfo, opts.IR, opts.PR);



% if(tipo==0)
%     Argb(:,:,1) = Argb(:,:,1);
%     Argb(:,:,2) = flipud(Argb(:,:,2));
%     Argb(:,:,3) = fliplr(Argb(:,:,3));
% end


%la normalizzazione viene fatta direttamente al task2, qui estraggo solo
%l'iride in coodinate polari 

radial_res = 64;
angular_res = 240;

[SYNRGBIrisImage] = PolarizeIris(Asynt_orig, EyeInfo.IrisInfo, EyeInfo.PupilInfo, angular_res, radial_res);
[VISRGBIrisImage] = PolarizeIris(Avis_orig, EyeInfo.IrisInfo, EyeInfo.PupilInfo, angular_res, radial_res);

if(verbose)
    EyeInfo.RGBIrisImage = SYNRGBIrisImage;
    figure(1);
    subplot(3,3,5);
    imshow(uint8(Argb));
    hold on;
    for i=1:8:n
        plot(Y(i), X(i), '^', 'Markerfacecolor', 'y', 'Color', 'k');
    end
    
    subplot(3,3,6);
    imshow(uint8(Argb));
    hold on;
    MajA = max([Ell(4) Ell(3)]);
    MinA = min([Ell(4) Ell(3)]);
    plot_ellipse(Radius2, Radius2, Ell(5), 0, [Ell(2) Ell(1)], 'm');
    plot_ellipse(Radius1, Radius1, 0, 0, [Iris.Cx Iris.Cy], 'c');

    dime = round(size(EyeInfo.RGBIrisImage, 2)/3 - 0.5);
    
    subplot(3,3,7);
    imshow(uint8(EyeInfo.RGBIrisImage(:, 1:dime, :)), []);
    
    subplot(3,3,8);
    imshow(uint8(EyeInfo.RGBIrisImage(:, dime+1:2*dime,  :)), []);
    
    subplot(3,3,9);
    imshow(uint8(EyeInfo.RGBIrisImage(:, 2*dime+1:3*dime, :)), []);
    drawnow;
end