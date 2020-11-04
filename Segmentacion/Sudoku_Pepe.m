% Sudoku

% Deteccion de entorno
close all;
clear all;


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

im1 = imread('Sudoku4.jpeg');
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
Ibw = ~im2bw(im1,graythresh(im1));
Ifill = imfill(Ibw,'holes');
figure;
imshow(Ifill);
Iarea = bwareaopen(Ifill,1000);
figure;
imshow(Iarea);
Ifinal = bwlabel(Iarea);
figure;
imshow(Ifinal);
stat = regionprops(Ifinal,'boundingbox','Area');
figure;
imshow(im1); hold on;
for cnt = 1 : numel(stat)
    if(stat(cnt).Area > 100000 && stat(cnt).Area < 600000)
        bb = stat(cnt).BoundingBox
        rectangle('position',bb,'edgecolor','r','linewidth',2);
        %I_grey  = rgb2gray(Ifinal);
        
        %p = [min(y), min(x), max(y)-min(y) , max(x)-min(x)]; % coordenadas rectángulo
        im_ob = imcrop(im1,bb); %subimagen con un único objeto en niveles de grises
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
                
                im_ob = imcrop(rotI,bb2); %subimagen con un único objeto en niveles de grises
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