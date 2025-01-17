function [NewMn] = PrunePoints(Mn, X, Y, dista)

NewMn = 0;
n = length(X);

d = 0;
for i=2:n
    d(i) = sqrt((X(i)-X(i-1)).^2 + (Y(i)-Y(i-1)).^2);
end

p = find(d>dista);

if(length(p)<1)
    return;
end

t = [round(diff([p n])/2)];

NewMn = Mn(round(p(1)/2));
NewMn = [NewMn Mn(p+t)];



