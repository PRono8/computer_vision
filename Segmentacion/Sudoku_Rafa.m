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
