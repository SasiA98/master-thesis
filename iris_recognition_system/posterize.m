function [Ap] = posterize(A,n)

[L,N] = superpixels(A,n);
BW = boundarymask(L);

Alab = rgb2lab(A);

pixel_idx = label2idx(L);

Aplab = Alab;
Ln = numel(L);
for k = 1:N
    idx = pixel_idx{k};
    Aplab(idx) = mean(Alab(idx));
    Aplab(idx+Ln) = mean(Alab(idx+Ln));
    Aplab(idx+2*Ln) = mean(Alab(idx+2*Ln));
end


Ap = lab2rgb(Aplab);

Ap=uint8(255*rescale(Ap));
