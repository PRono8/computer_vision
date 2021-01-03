%% Test segmentation
close all
clear all
clc
display_final = 1;


for i=1:8
    s1 = string("image");
    s2 = string(i);
    s3 = string("=imread('Sudoku");
    s4 = string(".jpeg');");
    s = strcat(s1,s2,s3,s2,s4);
    eval(s);
    
    s5 = string("[square,num_square] = find_squares(image");
    s6 = string(");");
    s = strcat(s5,s2,s6);
    eval(s);
    
    if(display_final == 1)
        figure(i)
%         s10 = string("title('Sudoku')");
%         str3 = strcat(s10,s2,s6);
%         eval(str3);
        subplot(1,num_square+1,1)
        s7 = string("imshow(image");
        str1 = strcat(s7,s2,s6);
        eval(str1);
        for j=1:num_square
            subplot(1,num_square+1,j+1)
            s8 = string("imshow(square.Image");
            s9 = string(j);
            str2 = strcat(s8,s9,s6);
            eval(str2);
        end
    end
end

for i=9:13
    s1 = string("image");
    s2 = string(i);
    s3 = string(" = imread('Sudoku");
    s4 = string(".jpg');");
    s = strcat(s1,s2,s3,s2,s4);
    eval(s);
    
    s5 = string("[square,num_square] = find_squares(image");
    s6 = string(");");
    s = strcat(s5,s2,s6);
    eval(s);
    
    if(display_final == 1)
        figure(i)
        subplot(1,num_square+1,1)
        s7 = string("imshow(image");
        str1 = strcat(s7,s2,s6);
        eval(str1);
        for j=1:num_square
            subplot(1,num_square+1,j+1)
            s8 = string("imshow(square.Image");
            s9 = string(j);
            str2 = strcat(s8,s9,s6);
            eval(str2);
        end
    end
end






















%% Cosas

% 8 no salen todos

% MAL: 8, 14, 15




% 
% image = imread('Sudoku14MAL.jpg');
% 
% [squares,num_squares] = find_squares(image)
% 
% % image = imread('Sudoku1.jpeg');
% % [square,num_square] = find_squares(image);



%     rectan = [];
%     for k = 1:num_squares
%         ob = (Iprocessed == IndSquare(k));
%         [x,y] = find(ob); % ob es una imagen con un solo objeto binario
%         p = [min(y), min(x), max(y)-min(y) , max(x)-min(x)]; % coordenadas rectángulo
%         rectan = [rectan; p];
%         im_ob = imcrop(Ibw,p); %subimagen con un único objeto en niveles de grises
%  
%         if(display3 == 1)
%             figure('NumberTitle', 'off', 'Name', 'Result');
%             %subplot(1,4,1)
%             imshow(im_ob)
%             title('Sudoku segmented');
% 
% %             subplot(1,4,2)
% %             imshow(ImR)
% %             title('Sudoku rotate');
% % 
% %             subplot(1,4,3)
% %             imshow(ImRb)
% %             title('Sudoku rotate and binarized');
% % 
% %             subplot(1,4,4)
% %             imshow(Sudoku)
% %             title('Extracted');    
%         end
%     end