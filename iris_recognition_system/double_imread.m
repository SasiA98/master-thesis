function [B] = double_imread(name)

B = imread(name);
% if(length(unique(B(:)))>10)
%     B = NormalizeColor(uint8(B));
% end
if(size(B,3)==1)
%     C=zeros(size(B));
%     C(:,:,1)=B;
%     C(:,:,2)=B;
%     C(:,:,3)=B;
%     B=C;

    h = fspecial("average", 16);
    Af = imfilter(B, h, 'same');
    Ag = uint8(16*double(B).*rescale(exp(log2(double(B)+1)-log2(double(Af)+1))));
    C=zeros(size(B,1), size(B,2), 3);
    C(:,:,1)=Ag;
    C(:,:,2)=Ag;
    C(:,:,3)=Ag;
    B=C;
end
B = imresize(B, [72, 96]);
B = rescale(im2double(B));
% B=B(1:96,1:64);
% B = double(B);