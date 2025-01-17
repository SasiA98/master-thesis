function [Xout, Yout] = sortpixels(X, Y)
    % Preallocazione
    Xout = [];
    Yout = [];
    
    % Crea una matrice logica usando l'indicizzazione diretta
    L = false(max(X), max(Y));
    L(sub2ind(size(L), X, Y)) = true;
    
    % Trova i contorni degli oggetti in L
    [B, ~, N, ~] = bwboundaries(L, 8, 'noholes');
    
    % Estrai i contorni e applica liftvector
    for k = 1:N
        P = B{k};
        Xout = [Xout, liftvector(P(:, 1)', 8)];
        Yout = [Yout, liftvector(P(:, 2)', 8)];
    end
end

function W = liftvector(V, k)
    n = length(V);
    
    if n > k
        p = floor(k / 2);
        Vext = [V(n-p+1:n), V, V(1:p)];
        W = zeros(1, n);
        
        for i = 1:n
            v = Vext(i:i+k-1);
            W(i) = round(mean(v));
        end
    else
        W = V;
    end
end

% function [Xout, Yout] = sortpixels(X,Y)
% 
% Xout = [];
% Yout = [];
% 
% L = zeros(max(X), max(Y));
% 
% for i=1:length(X)
%     L(X(i), Y(i)) = 1;
% end
% 
% [B,L,N,A] = bwboundaries(L, 8);
% 
% for k = 1:N
%     P = B{k};
%     Xout = [Xout, liftvector(P(:,1)', 8)];
%     Yout = [Yout, liftvector(P(:,2)', 8)];
% end
% 
% 
% 
% function W = liftvector(V, k)
% 
% n = length(V);
% 
% if(n>k)
%     p = floor(k/2);
%     
%     Vext = [V(n-p:n),V, V(1:p)];
%     W = V;
%     
%     for i=1:n
%         v = Vext(i:i+p);
%         m = mean(v);
%         W(i)=round(m);
%     end
% else
%     W=V;
% end
