function [curva] = calcolacurvatura(X,Y, stp)

n = length(X);

curva = 0;

segno = 1;   
% stp = 24;

% aviobj = avifile('example1.avi','compression','None');

for k=1:n
    
    p=rem(k+stp, n)+1;
    %curva(k) = sqrt((X(k)-X(p)).*(X(k)-X(p)) + (Y(k)-Y(p)).*(Y(k)-Y(p)));
    xm1 = round((X(k)+X(p))/2);
    ym1 = round((Y(k)+Y(p))/2);
    
    p2 = rem(round(k+stp/2), n)+1; 
    xm2 = X(p2);
    ym2 = Y(p2);
    
    curva(p2) = sqrt((xm1-xm2)^2 + (ym1-ym2)^2);
    
%     figure(1000);
%     hold off;
%     plot(Y,X, 'r-');
%     hold on;
%     line([Y(k) Y(p)], [X(k) X(p)]);
%     line([ym1 ym2], [xm1 xm2]);
%     %pause(0.01);
%     
%     F = getframe(1000);
%     aviobj = addframe(aviobj,F);
end

% aviobj = close(aviobj);

curva = curva/stp;
    %curva = curva/std(curva);