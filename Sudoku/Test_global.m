close all
clear all
clc

for i=1:8
    % Se guarda la imagen en image
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
end


for i=9:13
    % Se guarda la imagen en image
    s1 = string("image");
    s2 = string(i);
    s3 = string("=imread('Sudoku");
    s4 = string(".JPG');"); % O JPG
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
end



close all
clear all
clc
image = imread('Sudoku1.jpeg');
