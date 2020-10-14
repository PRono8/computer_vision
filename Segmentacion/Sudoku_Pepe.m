% Sudoku

% Deteccion de entorno
close all;
clear all;

im1 = imread('Sudoku1.jpeg');
im1g = rgb2gray(im1);
im1b = imbinarize(im1g, 'adaptive', 'sensitivity', 0.7);

im1bn = not(im1b);
figure,
imshow(im1bn);
im1bnAC = hough(im1bn);

p = houghpeaks(im1bnAC,5);
x = mean(p(:,2));


im1rotada = imrotate(im1,-34);
figure,
subplot(1,2,1);
imshow(im1);
subplot(1,2,2);
imshow(im1rotada);

I = im1rotada;


%I = imread('Sudoku1.jpeg');
Ibw = ~im2bw(I,graythresh(I));
Ifill = imfill(Ibw,'holes');
figure;
imshow(Ifill);
Iarea = bwareaopen(Ifill,100);
Ifinal = bwlabel(Iarea);
stat = regionprops(Ifinal,'boundingbox');
figure;
imshow(I); hold on;
for cnt = 1 : numel(stat)
    bb = stat(cnt).BoundingBox;
    rectangle('position',bb,'edgecolor','r','linewidth',2);
end