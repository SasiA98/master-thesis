function y = mediano(x, stp)

     y = x;
        
     for i=1:length(x)
         xstop = min(length(x), i+stp);
         y(i) = median(x(i:xstop));
     end