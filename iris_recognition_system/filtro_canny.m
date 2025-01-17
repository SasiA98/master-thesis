function [ImmagineFiltrata] = filtro_canny(Immagine, soglia)

if(isempty(soglia))
    ImmagineFiltrata = edge(Immagine, 'canny');
else
    ImmagineFiltrata = edge(Immagine, 'canny', soglia);
end