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
image=imread('Sudoku9.JPG');
[MSudokus,num_MSudokus] = sudoku(image);
%% 

figure
 %imagesc(MSudokus.Matrix)  
 a=MSudokus;
axis([0 10 0 10]);
axis ij;
axis off;
for i=1:length(a(1).Matrix)
    for j=1:length(a(1).Matrix)

   % [x,y]=ind2sub(i,j)

    text(j,i,num2str(a(1).Matrix(i,j)),'FontSize',12)
    end
end
title('Number Extraction','FontSize',14)
%     if(num_MSudokus > 0)
%         for j=1:num_MSudokus
%             MSudokus(j).Matrix
%         end
%     end

