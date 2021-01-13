function [n,rotado] = Num_Identification(im, rotar, mostrar)

%%% VARIABLES DE LA FUNCIÓN:
    % rotado: Te dice si detecta el número rotado
    %         0 -> No lo sé
    %         1 -> Correcto
    %         2 -> 90º
    %         3 -> 180º = invertido

    % rotar: Si es necesario comprobar la rot del núm
    %         0 -> Si, es necesario comprobar la rot del núm
    %         1 -> No es necesario comprobar
    %         2 -> Se debe rotar 90º (puede estar invertido)
    %         3 -> Se debe rotar 180º
    %         4 -> Se debe rotar 90º (ya comprobado que no está invertido)
    %         5 -> Se debe rotar -90º (ya comprobado que no está invertido)

    % Mostrar: si se deben mostrar los resultados (plots)
    %         0 -> No
    %         1 -> Si
    
    rotado = 0;                             % Inicializamos a cero y sobreescribiremos
    n = 0;
    
%%%%%% ROTAR IMAGEN %%%%%%%%%%
    if rotar == 2 || rotar == 4
        im = imrotate(im,90);
    elseif rotar == 3
        im = imrotate(im,180);
    elseif rotar == 5
        im = imrotate(im,-90);
    end
    
%%%%%% PROPERTIES OBTENCION %%%%%%%

%     im1 = bwmorph(im,'erode',1);           % Hace una erosión
%     im2 = bwmorph(im1,'dilate',1);          % 4 dilataciones
    
    esqueleto1 = bwmorph(im,'thin',inf);    % thin = adelagaza los objetos hasta líneas = esqueleto
    
    esqueleto = bwskel(im);
%     esqueleto = bwmorph(esqueleto,'dilate',1);
%     esqueleto1 = bwmorph(esqueleto1,'dilate',1);
%     esqueleto = bwmorph(esqueleto,'erode',1);
%     esqueleto1 = bwmorph(esqueleto1,'erode',1);
%     figure,
%     subplot(151);
%     imshow(im);
%     subplot(152);
%     imshow(im1);
%     subplot(153);
%     imshow(im2);
%     subplot(154);
%     imshow(esqueleto);
%     subplot(155);
%     imshow(esqueleto1);

    % ROI = esqueleto(50:140, 30:260);      % Nos quedamos la región de interés deseada
    % im1 = bwlabel(ROI);                   % Etiqueta reg coneectadas

    p = regionprops(esqueleto,'ConvexArea', 'EulerNumber', 'Centroid');   % Sacamos las propiedades

    ob1 = bwmorph(esqueleto,'endpoints');   % Sacamos los puntos finales
    ob2 = bwlabel(ob1);                     % Etiquetado de reg (los contamos)
    Pf = max(ob2(:));                       % Pf = Num de puntos finales

    Area = p.ConvexArea;
    Euler = p.EulerNumber;
    Cen(:) = p.Centroid;
    if (Pf > 0)                             % Si hay puntos finales
        [x,y] = find(ob2);
        Pfc(:) = [y(Pf),x(Pf)];             % Guadar el ultimo
    else
        Pfc = [0,0];
        x = 0;
        y = 0;
    end


    X_pf = Cen(1)-Pfc(1);                   % Posición relativa en Y del primer punto final respecto al centroide
    Y_pf = Cen(2)-Pfc(2);

    X_pi = Cen(1)-y(1);
    Y_pi = Cen(2)-x(1);

    area_im = size(im);
    area_total = area_im(1)*area_im(2);
    area_num = Area;
    porcentaje = area_num*100/area_total

    %%%%%% Clasificación de Números %%%%%%%
    
    switch (Euler)                           % Separa (8), (0,6,9,4) y (1,2,3,5,7)
     case (-1)                              % Dos huecos
        if (Pf==1)
            if(X_pf<0)                      % Separa (6) y (9)
                n = 6;                      % según centroide X
            else                            % y punto final
                n = 9;
            end
        elseif (Pf == 0)
            n = 8;
        else 
            n = 4;
        end
     case (0)                               % Un hueco
        if (Pf==1)
            if(X_pf<0 && Y_pf>0)                      % Separa (6) y (9)
                n = 6;                      % según centroide X
            elseif (X_pf >0)                            % y punto final
                n = 9;
            else
                n = 4;
            end
        else
            n = 4;
        end

     case (1)                               % Cero huecos
        if (Pf == 2)                  % 2 puntos finales
            if (Area>0.5*area_total)
                if (Y_pf > 0)
                    if (X_pf > 0)
                        n = 3;
                    else
                        n = 5;
                    end
                elseif (X_pf < 0)
                    n = 2;
                else
                    n = 3;
                end
            elseif (X_pf < 1 && Y_pf < 0)
                n = 1;
            else
                n = 7;
            end
        end
        if (Pf == 3)
            if (X_pf > 0)
                n = 3;
            elseif (Y_pf < 0)
                if (Y_pi < 0)
                    n = 5;
                else
                    n = 1;
                end
            end
        end
    end
    
    if mostrar == 1
          figure;
          subplot(221); imshow(im);         title('original')
          hold on
          text(10,20,num2str(n),'Color','r','BackgroundColor','g');
          subplot(222); imshow(ob1);        title('endpoints')
          hold on;    plot(Cen(1),Cen(2),'*r')
          hold on;    plot(Pfc(1),Pfc(2),'*b')
          hold on;    text(10,20,num2str(Pf),'Color','r','BackgroundColor','g');
          hold on;    plot(y(1),x(1),'*g');
          subplot(223); imshow(esqueleto);  title('esqueleto')
          subplot(224); imshow(esqueleto1); title('esqueleto1')
      
%         figure;     imshow(ob1);        title('endpoints')
%         hold on;    plot(Cen(1),Cen(2),'*r')
%         hold on;    plot(Pfc(1),Pfc(2),'*b')
%         hold on;    text(10,20,num2str(n),'Color','r','BackgroundColor','g');
      
%         figure; 
%       imshow(im); hold on
%       text(10,20,num2str(n),'Color','r','BackgroundColor','g');
    end
    
    if rotar == 0 && n ~= 0
        BBox = regionprops(esqueleto,'BoundingBox');
        ancho = BBox.BoundingBox(3);
        alto  = BBox.BoundingBox(4); 
        
        if ancho > alto
            rotado = 2;
        else
            rotar  = 2;      % Para comprobar si está invertido
        end
    end
    
    if rotar == 2 && (n == 3)
        switch n
            case 3
                if (Pf == 3 && X_pf < 0)
                    rotado = 3;
                else
                    rotado = 1;
                end
            case 2
                Y_pf = Cen(2)-Pfc(2);
                if Y_pf > -50
                    rotado = 3;
                else
                    rotado = 1;
                end
            case 7
                if X_pf < 0
                    rotado = 3;
                else
                    rotado = 1;  
                end
        end
    end
end

