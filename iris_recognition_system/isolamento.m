 function [iso] = isolamento(A, cx, cy, radius)

     ro1 = 0.9*radius;
     ro2 = 1.1*radius;
     step = 2*pi/360;
     h = 0;
     
     %B = A;
     
     i = 1;
     for theta=0:step:2*pi
         x1 = cy+round(ro1*cos(theta));
         y1 = cx+round(ro1*sin(theta));
         x2 = cy+round(ro2*cos(theta));
         y2 = cx+round(ro2*sin(theta));
         
         
         if(x1 > 0   &   y1 > 0 & y1 < size(A,2) & x1 < size(A,1) && x2 > 0   &   y2 > 0 & y2 < size(A,2) & x2 < size(A,1))
            h(i) = abs(A(x2, y2) - A(x1, y1));
            i = i+1;
            %B(x2, y2) = 255;
            %B(x1, y1) = 255;
         end
         
     end
     
     iso = mean(h)/(1+std(h));
     
%      figure(4)
%      imshow(B)
%      iso
%      input('a');