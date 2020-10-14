%% Ejercicio 13
clear all
%close all
%clc

%im3 = imread('Sudoku1.png');
im3 = imread('Sudoku2.jpeg');

im3g = rgb2gray(im3);
im3b3 = imbinarize(im3g,'adaptive','Sensitivity',0.7);
im3b3n = abs(im3b3-1);

figure
subplot(1,2,1)
imshow(im3b3);
subplot(1,2,2)
imshow(im3b3n);

im3ac = hough(im3b3n);


%% Ejercicio 14

% figure
% surf(im3ac)
% shading interp


%% Ejercicio 15

p3 = houghpeaks(im3ac,1);
m3 = mean(p3(:,2));


%% Ejercicio 16

% figure
% imshow(im3ac,[])
% hold on
% plot(p3(:,2),p3(:,1),'go');
% axis square


%% Ejercicio 17

im3r = imrotate(im3,m3-90);
subplot(1,3,1)
imshow(im3b3);
subplot(1,3,2)
imshow(im3b3n);
subplot(1,3,3)
imshow(im3r)
