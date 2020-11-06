%% CÓDIGO PEPE

% Deteccion de entorno
close all;
clear all;

%% Parámetros
open = 1000; % Eliminación de objetos pequeños
min_area = 20; % Eliminación de objetos pequeños

%% Preprocesado
% Lectura de imagen
im1 = imread('Sudoku2.jpeg');

    figure(1)
    subplot(1,5,1)
    imshow(im1)
    title('Imagen original')

% Binariazación usando el método de Otsu
Ibw = ~im2bw(im1,graythresh(im1));
    subplot(1,5,2)
    imshow(Ibw)
    title('Imagen Binarizada')

%% Procesado
% Rellena los huecos
Ifill = imfill(Ibw,'holes');
    subplot(1,5,3)
    imshow(Ifill)
    title('Imagen rellena')

% Elimina los objetos pequeños
Iarea = bwareaopen(Ifill,open);
    subplot(1,5,4)
    imshow(Iarea)
    title('Imagen sin objetos pequeños')

% Etiqueta las regiones conectadas 
Ifinal = bwlabel(Iarea);
    subplot(1,5,5)
    imshow(Ifinal,[])
    colormap(gca,[0,0,0;colorcube])
    title('Regiones conectadas')

n_etiquetas = max(max(Ifinal));

%% Identificación

% Imagen binarizada, rellena, de cerco convexo y su área
prop_im1 = regionprops(Ifinal,'Image','ConvexImage','Area');

% Muestra la signatura de cada objeto
figure
cont = 1;

%save('signatura_cuadrado.mat','signatura_referencia')
load('signatura_cuadrado.mat','signatura_referencia')

for k = 1:numel(prop_im1)
    % Elimina areas pequeñas
    if (prop_im1(k).Area > min_area)
        subplot(numel(prop_im1),3,cont)
        imshow(prop_im1(k).Image);
        subplot(numel(prop_im1),3,cont+1)
        imshow(prop_im1(k).ConvexImage);
        subplot(numel(prop_im1),3,cont+2)
        % Cálculo de la signatura normalizada
        signatura = signatura_isa(prop_im1(k).ConvexImage);
        plot(signatura(:,1),signatura(:,2));
        cont=cont+3;
        
        windowSize = 100; 
        b = (1/windowSize)*ones(1,windowSize);
        a = 1;
        y = filter(b,a,signatura(:,2));
        pk = findpeaks(y);
        picos = find(pk > 0.9);
        nun_picos = size(picos);
        picos = nun_picos(1)
        
        
%         tam = size(signatura(:,2));
%         %[pks,locs] = findpeaks(signatura(:,2))
%         pk = findpeaks(signatura(:,2),'MinPeakDistance',tam(1)/10);
%         picos = find(pk > 0.8);
%         nun_picos = size(picos);
%         picos = nun_picos(1)
        
        % [pks,locs]
         % 'MinPeakProminence',0.2
        
        
%        % Hasta pi/4
%         tam1 = size(signatura(:,1));
%         tam2 = size(signatura(:,2));
%         pi_cuartos = signatura([1:tam1/4],1);
%         valor = signatura([1:tam2/4],2);
%         plot(pi_cuartos,valor);
        
    end
end






%% 
% Área de cada region y su posición (esquina superior izquierda)
stat = regionprops(Ifinal,'boundingbox','Area');


for cnt = 1 : numel(stat)
    if(stat(cnt).Area > 100000 && stat(cnt).Area < 600000)
        bb = stat(cnt).BoundingBox
        rectangle('position',bb,'edgecolor','r','linewidth',2);
        %I_grey  = rgb2gray(Ifinal);
        
        %p = [min(y), min(x), max(y)-min(y) , max(x)-min(x)]; % coordenadas rectÃ¡ngulo
        im_ob = imcrop(im1,bb); %subimagen con un Ãºnico objeto en niveles de grises
        figure;
        imshow(im_ob,[]);
        
        im_ob = rgb2gray(im_ob);
        
        BW = edge(im_ob,'canny');

        [H,theta,rho] = hough(BW);

        peak = houghpeaks(H,1);
        barAngle = theta(peak(:,2));
        ang = mean(mean(barAngle));

        rotI = imrotate(im1,ang,'crop');
        BW = imrotate(BW,ang);

        figure,
        imshow(rotI);

        figure,
        imshow(BW);
        
        Ibw = ~im2bw(rotI,graythresh(rotI));
        Ifill = imfill(Ibw,'holes');
        figure;
        imshow(Ifill);
        Iarea = bwareaopen(Ifill,10000);
        figure;
        imshow(Iarea);
        Ifinal = bwlabel(Iarea);
        figure;
        imshow(Ifinal);
        stat2 = regionprops(Ifinal,'boundingbox','Area');
        figure;
        imshow(rotI); hold on;
        for cnt2 = 1 : numel(stat2)
            if(stat2(cnt2).Area > 300000 && stat2(cnt2).Area < 6000000)
                bb2 = stat2(cnt2).BoundingBox
                rectangle('position',bb2,'edgecolor','r','linewidth',2);
                
                im_ob = imcrop(rotI,bb2); %subimagen con un Ãºnico objeto en niveles de grises
                figure;
                imshow(im_ob,[]);

                im_ob = rgb2gray(im_ob);

                BW = edge(im_ob,'canny');
                figure('Name', 'Canny objeto'),
                imshow(BW);
                [H,T,R] = hough(BW); 
                imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit'); 
                xlabel('\theta'), ylabel('\rho'); axis on, axis normal, hold on;

                P  = houghpeaks(H,1000000,'threshold',ceil(0.3*max(H(:)))); x = T(P(:,2)); y = R(P(:,1)); plot(x,y,'s','color','white');

                lines = houghlines(BW,T,R,P,'FillGap',1000000,'MinLength',10); 
                figure, 
                imshow(BW), 
                hold on 
                max_len = 0; 
                for k = 1:length(lines)    
                    xy = [lines(k).point1; lines(k).point2];    
                    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');   
                    % Plot beginnings and ends of lines    
                    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');    
                    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');     
                    % Determine the endpoints of the longest line segment    
                    len = norm(lines(k).point1 - lines(k).point2);    
                    if ( len > max_len)       
                        max_len = len;       
                        xy_long = xy;    
                    end
                end
            end
        end
    end
end



































%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pruebas MATLAB 2
close all
clear
clc

%% Load Image
frame = imread('Sudoku3.jpeg');
figure(1)
subplot(1,4,1)
imshow(frame)
title('Sudoku')

%% Preprocesado

% Mask
img = rgb2gray(frame);
imb =  imbinarize(img,'adaptive','Sensitivity',0.7);
BW = abs(imb-1);
subplot(1,4,2)
imshow(BW)
title('Binarizado')

% Apply a skeleton morphology to get the thinnest lines
BMSkel = bwmorph(BW,'skel',1);
subplot(1,4,3)
imshow(BMSkel)
title('Skeletonized Lines')

BMDil = bwmorph(BMSkel,'dilate',0);
subplot(1,4,4)
imshow(BMDil)
title('Skeletonized Lines')

im_processing = BMDil;

%% Rotación
[H,T,R] = hough(im_processing);
% Se extrae el mayor pico
P  = houghpeaks(H,1);
% Se obtiene la posición del pico
x = T(P(:,2));
% Se obtiene el ángulo del pico
ang = mean(mean(x));
% Se rota la imagen
impr = imrotate(im_processing,ang);
imr = imrotate(frame,ang);

figure
subplot(1,2,1)
imshow(impr)
subplot(1,2,2)
imshow(imr)

rotI = imr;
BW = impr;

%% Detect Lines
[H,T,R] = hough(BW);

P  = houghpeaks(H,10,'threshold',ceil(0.3*max(H(:))));
x = T(P(:,2));
y = R(P(:,1));

L = [x;y]';

lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',7);

figure
imshow(rotI), 
hold on 

max_len = 0; 
for k = 1:length(lines)    
    xy = [lines(k).point1; lines(k).point2];    
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    
    % Plot beginnings and ends of lines    
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');    
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');     % Determine the endpoints of the longest line segment    
    len = norm(lines(k).point1 - lines(k).point2);    
    if ( len > max_len)       
        max_len = len;       
        xy_long = xy;    
    end 
end
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','cyan');


%% Pruebas MATLAB Github
close all
clear
clc

%% Load Image
frame = imread('Sudoku3.jpeg');
figure(1)
subplot(1,4,1)
imshow(frame)
title('Sudoku')

%% Preprocesado

% Mask
img = rgb2gray(frame);
imb = imbinarize(img,'adaptive','Sensitivity',0.7);
BW = abs(imb-1);
subplot(1,4,2)
imshow(BW)
title('Binarizado')

% % Apply a close morphology to make continuous lines
% BM = imclose(BW,strel('disk',3));
% subplot(1,4,3)
% imshow(BM)
% title('Continuous Lines')

% Apply a skeleton morphology to get the thinnest lines
BMSkel = bwmorph(BW,'skel',inf);
subplot(1,4,3)
imshow(BMSkel)
title('Skeletonized Lines')

BMDil = bwmorph(BMSkel,'dilate',1);
subplot(1,4,4)
imshow(BMDil)
title('Skeletonized Lines')

%% Detect Lines
% Perform Hough Transform
[H,T,R] = hough(BMDil);

% Identify Peaks in Hough Transform
hPeaks =  houghpeaks(H,4,'NHoodSize',[55 11]);

% Extract lines from hough transform and peaks
hLines = houghlines(BMDil,T,R,hPeaks,...
        'FillGap',100,'MinLength',100);

%% View results
% Overlay lines
[linePos,markerPos] = getVizPosArray(hLines);

lineFrame = insertShape(frame,'Line',linePos,...
            'Color','blue','LineWidth',5);
outFrame = insertObjectAnnotation(lineFrame,...
            'circle',markerPos,'','Color','yellow','LineWidth',5);

% View image
figure(5)
imshow(outFrame)
title('Detected Lines')




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Práctica

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







%% Ejemplo

clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.
fontSize = 20;
% % Change the current folder to the folder of this m-file.
% if(~isdeployed)
%   cd(fileparts(which(mfilename)));
% end
    
% % Ask user if they want to use a demo image or a different image.
% message = sprintf('Do you want use a standard demo image,\nOr pick one of your own?');
% reply2 = questdlg(message, 'Which Image?', 'Demo','I will pick a different one...', 'Demo');
% if isempty(reply2)
%   % They clicked the red x to close without clicking a button.
%   return;
% end
% % Open an image.
% if strcmpi(reply2, 'Demo')
%   % Read standard MATLAB demo image.
%   message = sprintf('Which demo image do you want to use?');
%   selectedImage = questdlg(message, 'Which Demo Image?', 'Square', 'Triangle', 'Circle', 'Circle');
%   if strcmp(selectedImage, 'Circle')
%     fullImageFileName = 'Circle.jpg';
%   elseif strcmp(selectedImage, 'Square')
%     fullImageFileName = 'Square.jpg';
%   else
%     fullImageFileName = 'Triangle.jpg';
%   end
% else
%   % They want to pick their own.
%   % Browse for the image file. 
%   [baseFileName, folder] = uigetfile('*.*', 'Specify an image file'); 
%   fullImageFileName = fullfile(folder, baseFileName); 
%   if folder == 0
%     return;
%   end
% end
% % Check to see that the image exists.  (Mainly to check on the demo images.)
% if ~exist(fullImageFileName, 'file')
%   message = sprintf('This file does not exist:\n%s', fullImageFileName);
%   uiwait(msgbox(message));
%   return;
% end




% Read in image into an array.
[rgbImage storedColorMap] = imread('Sudoku2.jpeg'); 
[rows columns numberOfColorBands] = size(rgbImage); 
% If it's monochrome (indexed), convert it to color. 
% Check to see if it's an 8-bit image needed later for scaling).
if strcmpi(class(rgbImage), 'uint8')
  % Flag for 256 gray levels.
  eightBit = true;
else
  eightBit = false;
end
if numberOfColorBands == 1
  if isempty(storedColorMap)
    % Just a simple gray level image, not indexed with a stored color map.
    % Create a 3D true color image where we copy the monochrome image into all 3 (R, G, & B) color planes.
    rgbImage = cat(3, rgbImage, rgbImage, rgbImage);
  else
    % It's an indexed image.
    rgbImage = ind2rgb(rgbImage, storedColorMap);
    % ind2rgb() will convert it to double and normalize it to the range 0-1.
    % Convert back to uint8 in the range 0-255, if needed.
    if eightBit
      rgbImage = uint8(255 * rgbImage);
    end
  end
end 
% Display the original image.
subplot(2, 2, 1);
imshow(rgbImage);
set(gcf, 'Position', get(0,'Screensize')); % Enlarge figure to full screen.
set(gcf,'name','Demo by ImageAnalyst','numbertitle','off') 
drawnow; % Make it display immediately. 
if numberOfColorBands > 1 
  title('Original Color Image', 'FontSize', fontSize); 
  grayImage = rgbImage(:,:,1);
else 
  caption = sprintf('Original Indexed Image\n(converted to true color with its stored colormap)');
  title(caption, 'FontSize', fontSize);
  grayImage = rgbImage;
end
% Display it.
subplot(2, 2, 2);
imshow(grayImage, []);
title('Grayscale Image', 'FontSize', fontSize);
% Binarize the image.
binaryImage = grayImage < 100;
% Display it.
subplot(2, 2, 3);
imshow(binaryImage, []);
title('Binary Image', 'FontSize', fontSize);
% Remove small objects.
binaryImage = bwareaopen(binaryImage, 300);
% Display it.
subplot(2, 2, 4);
imshow(binaryImage, []);
title('Cleaned Binary Image', 'FontSize', fontSize);
[labeledImage numberOfObjcts] = bwlabel(binaryImage);
blobMeasurements = regionprops(labeledImage,'Perimeter','Area'); 
% for square ((a>17) && (a<20))
% for circle ((a>13) && (a<17))
% for triangle ((a>20) && (a<30))
circularities = [blobMeasurements.Perimeter.^2] ./ (4 * pi * [blobMeasurements.Area])
% Say what they are
for blobNumber = 1 : numberOfObjcts
  if circularities(blobNumber) < 1.19
    message = sprintf('The circularity of object #%d is %.3f, so the object is a circle',...
      blobNumber, circularities(blobNumber));
  elseif circularities(blobNumber) < 1.53
    message = sprintf('The circularity of object #%d is %.3f, so the object is a square',...
      blobNumber, circularities(blobNumber));
  else
    message = sprintf('The circularity of object #%d is %.3f, so the object is a triangle',...
      blobNumber, circularities(blobNumber));
  end
  uiwait(msgbox(message));
end
