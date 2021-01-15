    %%Prueba global
close all;
% Se guarda la imagen en image
i=7;
    s1 = string("image");
    s2 = string(i);
    s3 = string("=imread('Sudoku");
    s4 = string(".JPEG');"); % O JPG
    st1 = strcat(s1,s2,s3,s2,s4);
    eval(st1);
    % Se llama a la función que devuelve MSudoku 
    s5 = string("[MSudokus,num_MSudokus] = sudoku(image");
    s6 = string(");");
    st2 = strcat(s5,s2,s6);
    eval(st2);
    
    if(num_MSudokus > 0)
        for j=1:num_MSudokus
            MSudokus(j).Matrix
        end
    end
%%    %%Prueba global
close all;
% Se guarda la imagen en image
i=7;
image=imread('4.JPEG');
[MSudokus,num_MSudokus] = sudoku(image);
%% 
close all

imagefondo=imread('plantilla.jpeg');
figure (25)
factor_cambio_x=length(imagefondo(:,1,1))/18;
factor_cambio_y=length(imagefondo(1,:,1))/18;

axis([0 length(imagefondo(:,1)) 0 length(imagefondo(:,1))]);
axis ij;
axis off;
imshow(imagefondo), hold on;
 %imagesc(MSudokus.Matrix)  
 a=MSudokus;
conty=0;
for i=1:length(a(1).Matrix)
    contx=0;
    for j=1:length(a(1).Matrix)

   % [x,y]=ind2sub(i,j)

    text((j+contx)*factor_cambio_x -2 ,(i+conty)*factor_cambio_y ,num2str(a(1).Matrix(i,j)),'FontSize',12)
    contx=contx+1;
    end
    conty=conty+1;
end
title('Number Extraction','FontSize',14)
%     if(num_MSudokus > 0)
%         for j=1:num_MSudokus
%             MSudokus(j).Matrix
%         end
%     end

