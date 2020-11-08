% Sudoku


% Deteccion de entorno
close all;
clear all;

%% Parámetros
open = 1000; % Eliminación de objetos pequeños
min_area = 10000; % Eliminación de objetos pequeños

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
prop_im1 = regionprops(Ifinal,'Image','ConvexImage','Area','boundingbox');

% Muestra la signatura de cada objeto
figure
cont = 1;
cont2 = 1;

%save('signatura_cuadrado.mat','signatura_referencia')
load('signatura_cuadrado.mat','signatura_referencia')

cuadrados = [];
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
        local_min = islocalmin(signatura(:,2));              % Cálculo de mínimos locales
        %signatura(:,2) = signatura(:,2)/signatura(:,local_min);
        plot(signatura(:,1),signatura(:,2));
        cont=cont+3;
        
        num_picos = 0;
        num_picosmin = 0;
        tam = size(signatura(:,1));
        tam2 = floor(tam(1)/6);
        for i = 0:5
            x = [(i*tam2+1):(i*tam2+tam2)];
            maximo = max(signatura(x,2));
            minimo = min(signatura(x,2));
            if(maximo > 0.92)
                num_picos = num_picos + 1;
            end    
            if(minimo < 0.07)
                num_picosmin = num_picosmin + 1;
            end  
        end
        
        num_picos
        num_picosmin
        
        if(num_picos == 4 && num_picosmin == 4)
            cuadrados(cont2) = k;
            cont2 = cont2+1;
        end
    end
end

cuadrados
cont2

%% 
% Área de cada region y su posición (esquina superior izquierda)
stat = regionprops(Ifinal,'boundingbox','Area');

BW=prop_im1(cuadrados).ConvexImage;
% BW = edge(prop_im1(cuadrados).ConvexImage,'canny');
% figure,
% imshow(BW);
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
stat = regionprops(BW,'boundingbox','Area');
for cnt = 1:numel(stat)
    bb = stat(cnt).BoundingBox
    rectangle('position',bb,'edgecolor','r','linewidth',2);
    im_ob = imcrop(rotI,bb);
    figure;
    imshow(im_ob,[]);
    num_sudokus = size(cuadrados);
end


for cnt = 1 : num_sudokus(2)
    %if(stat(cnt).Area > 100000 && stat(cnt).Area < 600000)
        bb = prop_im1(cuadrados(cnt)).BoundingBox
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








% Deteccion de entorno
% close all;
% clear all;


% I = imread('Sudoku4.jpeg');
% 
% I_grey  = rgb2gray(I);
% 
% BW = edge(I_grey,'canny');
% 
% [H,theta,rho] = hough(BW);
% 
% peak = houghpeaks(H,1);
% barAngle = theta(peak(:,2));
% ang = mean(mean(barAngle));
% 
% rotI = imrotate(I,ang,'crop');
% BW = imrotate(BW,ang);
% 
% figure,
% imshow(rotI);
% 
% figure,
% imshow(BW);
% 
% 
% [H,T,R] = hough(BW); 
% imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit'); 
% xlabel('\theta'), ylabel('\rho'); axis on, axis normal, hold on;
% 
% P  = houghpeaks(H,20,'threshold',ceil(0.3*max(H(:)))); x = T(P(:,2)); y = R(P(:,1)); plot(x,y,'s','color','white');
% 
% lines = houghlines(BW,T,R,P,'FillGap',20,'MinLength',7); 
% figure, 
% imshow(BW), 
% hold on 
% max_len = 0; 
% for k = 1:length(lines)    
%     xy = [lines(k).point1; lines(k).point2];    
%     plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');   
%     % Plot beginnings and ends of lines    
%     plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');    
%     plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');     
%     % Determine the endpoints of the longest line segment    
%     len = norm(lines(k).point1 - lines(k).point2);    
%     if ( len > max_len)       
%         max_len = len;       
%         xy_long = xy;    
%     end
% end

% im1 = imread('Sudoku4.jpeg');
% BW = edge(rotI,'canny');
% 
% 
% 
% im1g = rgb2gray(im1);
% im1b = imbinarize(im1g, 'adaptive', 'sensitivity', 0.7);
% 
% im1bn = not(im1b);
% figure,
% imshow(im1bn);
% im1bn_edge = edge(im1bn,'Canny');
% figure,
% imshow(im1bn_edge);
% im1bn_edge_dilate = bwmorph(im1bn_edge,'dilate',5);
% im1bn_edge_dilate_erode = bwmorph(im1bn_edge_dilate,'erode',5);
% figure,
% imshow(im1bn_edge_dilate_erode);
% 
% im1bnAC = hough(im1bn_edge_dilate_erode);
% 
% p = houghpeaks(im1bnAC,40);
% x = mean(p(:,2));
% 
% 
% im1rotada = imrotate(im1,x,'bilinear','crop');
% im1bnACrotada = imrotate(im1bnAC,-34);
% figure,
% subplot(1,2,1);
% imshow(im1);
% subplot(1,2,2);
% imshow(im1rotada);
% 
% I = im1rotada;


%I = imread('Sudoku1.jpeg');
% Ibw = ~im2bw(im1,graythresh(im1));
% Ifill = imfill(Ibw,'holes');
% figure;
% imshow(Ifill);
% Iarea = bwareaopen(Ifill,1000);
% figure;
% imshow(Iarea);
% Ifinal = bwlabel(Iarea);
% figure;
% imshow(Ifinal);
% stat = regionprops(Ifinal,'boundingbox','Area');
% figure;
% imshow(im1); hold on;
% for cnt = 1 : numel(stat)
%     if(stat(cnt).Area > 100000 && stat(cnt).Area < 600000)
%         bb = stat(cnt).BoundingBox
%         rectangle('position',bb,'edgecolor','r','linewidth',2);
%         %I_grey  = rgb2gray(Ifinal);
%         
%         %p = [min(y), min(x), max(y)-min(y) , max(x)-min(x)]; % coordenadas rectángulo
%         im_ob = imcrop(im1,bb); %subimagen con un único objeto en niveles de grises
%         figure;
%         imshow(im_ob,[]);
%         
%         im_ob = rgb2gray(im_ob);
%         
%         BW = edge(im_ob,'canny');
% 
%         [H,theta,rho] = hough(BW);
% 
%         peak = houghpeaks(H,1);
%         barAngle = theta(peak(:,2));
%         ang = mean(mean(barAngle));
% 
%         rotI = imrotate(im1,ang,'crop');
%         BW = imrotate(BW,ang);
% 
%         figure,
%         imshow(rotI);
% 
%         figure,
%         imshow(BW);
%         
%         Ibw = ~im2bw(rotI,graythresh(rotI));
%         Ifill = imfill(Ibw,'holes');
%         figure;
%         imshow(Ifill);
%         Iarea = bwareaopen(Ifill,10000);
%         figure;
%         imshow(Iarea);
%         Ifinal = bwlabel(Iarea);
%         figure;
%         imshow(Ifinal);
%         stat2 = regionprops(Ifinal,'boundingbox','Area');
%         figure;
%         imshow(rotI); hold on;
%         for cnt2 = 1 : numel(stat2)
%             if(stat2(cnt2).Area > 300000 && stat2(cnt2).Area < 6000000)
%                 bb2 = stat2(cnt2).BoundingBox
%                 rectangle('position',bb2,'edgecolor','r','linewidth',2);
%                 
%                 im_ob = imcrop(rotI,bb2); %subimagen con un único objeto en niveles de grises
%                 figure;
%                 imshow(im_ob,[]);
% 
%                 im_ob = rgb2gray(im_ob);
% 
%                 BW = edge(im_ob,'canny');
%                 figure('Name', 'Canny objeto'),
%                 imshow(BW);
%                 [H,T,R] = hough(BW); 
%                 imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit'); 
%                 xlabel('\theta'), ylabel('\rho'); axis on, axis normal, hold on;
% 
%                 P  = houghpeaks(H,1000000,'threshold',ceil(0.3*max(H(:)))); x = T(P(:,2)); y = R(P(:,1)); plot(x,y,'s','color','white');
% 
%                 lines = houghlines(BW,T,R,P,'FillGap',1000000,'MinLength',10); 
%                 figure, 
%                 imshow(BW), 
%                 hold on 
%                 max_len = 0; 
%                 for k = 1:length(lines)    
%                     xy = [lines(k).point1; lines(k).point2];    
%                     plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');   
%                     % Plot beginnings and ends of lines    
%                     plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');    
%                     plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');     
%                     % Determine the endpoints of the longest line segment    
%                     len = norm(lines(k).point1 - lines(k).point2);    
%                     if ( len > max_len)       
%                         max_len = len;       
%                         xy_long = xy;    
%                     end
%                 end
%             end
%         end
%     end
% end