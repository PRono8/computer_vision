close all
clear all
clc

% image = imread('Sudoku1.jpeg');
% [square,num_square] = find_squares(image);

for i=1:5
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
end