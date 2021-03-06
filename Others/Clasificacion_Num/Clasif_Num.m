                    %%%%%% Clasificación de Números %%%%%%%
clear; close all; clc; 

% k=9;
% for k = [k 10+k 20+k 30+k]
for k = 1:40
    pause(1);
    close;
    im = imread(strcat('Num_', num2str(k),'.jpeg'));
    % figure;imshow(im);

    imh = histeq(im);                       % Mejora el contraste mediante la ecualización del histograma
    imbw = im2bw(imh,0.2);                  % Convertir imagen a imagen binaria, basada en umbral
    imf = not(imbw);                        % Inviwerte (para tener números en blanco)
%      figure;imshow(imf)
    im1 = bwmorph(imf,'erode',4);           % Hace una erosión
    im2 = bwmorph(im1,'dilate',4);          % 4 dilataciones
%      figure;imshow(im2)
    esqueleto = bwmorph(im2,'thin',inf);    % thin = adelagaza los objetos hasta líneas = esqueleto
%       figure; imshow(esqueleto);
    % figure;imshow(double(im).*not(esqueleto)+esqueleto*256,[gray(255);0 1 0]);

    % ROI = esqueleto(50:140, 30:260);      % Nos quedamos la región de interés deseada
    % im1 = bwlabel(ROI);                   % Etiqueta reg coneectadas

    p = regionprops(esqueleto,'ConvexArea', 'EulerNumber', 'Centroid');   % Sacamos las propiedades

    % ob = (esqueleto == 1);
    ob1 = bwmorph(esqueleto,'endpoints');   % Sacamos los puntos finales
    ob2 = bwlabel(ob1);                     % Etiquetado de reg (los contamos)
    Pf = max(ob2(:));                       % Pf = Num de puntos finales
%       figure; imshow(ob2);

    Area = p.ConvexArea;
    Euler = p.EulerNumber;
    Cen(:) = p.Centroid;
    if (Pf > 0)                             % Si hay puntos finales
        [x,y] = find(ob2);
        Pfc(:) = [y(Pf),x(Pf)];             % Guadar el ultimo
    else
        Pfc = [0,0];
    end

    
    X_pf = Cen(1)-Pfc(1);                   % Posición relativa en Y del primer punto final respecto al centroide
    v = [Euler, Pf, Area, X_pf ]

    switch (v(1))                           % Separa (8), (0,6,9,4) y (1,2,3,5,7)
     case (-1)                              % Dos huecos
        n = 8;

     case (0)                               % Un hueco
        if (v(2)==1)
            if(v(4)<0)                      % Separa (6) y (9)
                n = 6;                      % según centroide X
            else                            % y punto final
                n = 9;
            end
        else
            n = 4;
        end

     case (1)                               % Cero huecos
        if (v(2) == 4)                      % 4 ptos finales
            n = 5;  
        elseif (v(2) == 2)                  % 2 puntos finales
            if (v(3)>6000)
                n = 2;
            else
                n = 7;
            end
        elseif (v(2) == 3)                  % 3 puntos finales (1,3 y 7)
            if (v(3) < 3000)
                n = 1;                      % 3 => Y_pf positivo
            elseif (v(4)<0)
                n = 5;                      % área de 5
            else
                n = 3;
            end
        end
    end

    figure, imshow(im); hold on
    text(10,20,num2str(n),'Color','r','BackgroundColor','g');
end
pause(1);
close;
