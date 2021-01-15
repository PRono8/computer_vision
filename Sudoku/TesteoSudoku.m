%% Testeo
img1=imread('3.jpeg');

[a,b]=find_sudoku(img1);
img1=imcomplement(a.Image);

image_cell=find_cells(img1,1);
%% Plot Image
figure
imshow(img1)
title('Test Image 1', 'FontSize',12)
%% Plot Global
figure
imshow(a.Image1)
title('Global Segmentation','FontSize',12)
%% Plot Cells
figure
title('Cells Extraction','FontSize',12)
for i=1:81
    subplot(9,9,i)
    imshow(image_cell{i})
    
end

%% Plot Numbers
figure 
% sudoku global con los numeros que reconoce, podemos hacer zoom en algunos
% en concreto si no se ve bien
imshow()

