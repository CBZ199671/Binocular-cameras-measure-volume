
clc
clear
%设定参数-----------------------%
ImWidth = 2048; %生成图像大小
ImHeigth = 1536;
BoxSize = 128;%标定块大小
%初始矩阵-----------------------%
Immat = zeros(ImWidth,ImHeigth);
Immat = uint8(Immat);
%Boxmat = ones(BoxSize,BoxSize);
Wind = ImWidth / BoxSize;
Hind = ImHeigth / BoxSize;
for i = 1 : 2 : Wind
 for j = 1 : 2 : Hind
     Immat((1 + BoxSize * (i-1)):(BoxSize + BoxSize * (i-1)),(1 + BoxSize * (j-1)):(BoxSize + BoxSize * (j-1))) = uint8(255); 
 end
end
for i = 2 : 2 : Wind
 for j = 2 : 2 : Hind
     Immat((1 + BoxSize * (i-1)):(BoxSize + BoxSize * (i-1)),(1 + BoxSize * (j-1)):(BoxSize + BoxSize * (j-1))) = uint8(255);
 end
end
imshow(Immat);
imwrite(Immat,'biaoding.bmp','bmp');
