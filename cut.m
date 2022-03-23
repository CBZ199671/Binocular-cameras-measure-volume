clc;
clear;
close all;

file_path =  'C:\Users\huolo\Desktop\Object-Volume-Measurement-Based-On-Binocular-Vision-master\originalimg\';
saveleft_path = 'C:\Users\huolo\Desktop\Object-Volume-Measurement-Based-On-Binocular-Vision-master\left\';
saveright_path = 'C:\Users\huolo\Desktop\Object-Volume-Measurement-Based-On-Binocular-Vision-master\right\';

img_path_list = dir(strcat(file_path,'*.bmp'));  
img_num = length(img_path_list);
I=cell(1,img_num);
if img_num > 0  
    for j = 1:img_num  
        image_name = img_path_list(j).name;
        image =  imread(strcat(file_path,image_name));  
        I{j} = image; 
        fprintf('%d %d %s\n',1i,j,strcat(file_path,image_name));
        
        [m,n] = size(image);
        midelx = 1280;

        rect1 = [0 0 midelx 720];
        rect2 = [1281 0 1280 720];

        L = imcrop(image,rect1);
        R = imcrop(image,rect2);
        saveleft = [saveleft_path,['left',image_name]];
        saveright = [saveright_path,['right',image_name]];
        imwrite(L,saveleft)
        imwrite(R,saveright)
        
        figure
        subplot(131),imshow(image);
        rectangle('Position',rect1,'LineWidth',2,'EdgeColor','r')
        subplot(132),imshow(L);
        subplot(133),imshow(R); 
    end  
end




