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
image=imread('1.JPEG');
[MSudokus,num_MSudokus] = sudoku(image);

figure
 %imagesc(MSudokus.Matrix)  
 a=MSudokus;
axis([0 9 0 9]);
for b=1:numel(a)

[x,y]=ind2sub(size(a),b)

text(x,y,num2str(a(b)))
end
%     if(num_MSudokus > 0)
%         for j=1:num_MSudokus
%             MSudokus(j).Matrix
%         end
%     end

