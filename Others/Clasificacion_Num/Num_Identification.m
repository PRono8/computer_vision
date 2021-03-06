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

    imh = histeq(im);                       % Mejora el contraste mediante la ecualización del histograma
    imbw = im2bw(imh,0.2);                  % Convertir imagen a imagen binaria, basada en umbral
    imf = not(imbw);                        % Inviwerte (para tener números en blanco)

    im1 = bwmorph(imf,'erode',4);           % Hace una erosión
    im2 = bwmorph(im1,'dilate',4);          % 4 dilataciones

    esqueleto = bwmorph(im2,'thin',inf);    % thin = adelagaza los objetos hasta líneas = esqueleto

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
    end


    X_pf = Cen(1)-Pfc(1);                   % Posición relativa en Y del primer punto final respecto al centroide
    v = [Euler, Pf, Area, X_pf ];

    %%%%%% Clasificación de Números %%%%%%%
    
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
    
    if mostrar == 1
        figure;
      subplot(221); imshow(im);         title('original')  
      subplot(222); imshow(imf);        title ('binaria')
      subplot(223); imshow(im2);        title('cerrada')
      subplot(224); imshow(esqueleto);  title('esqueleto')
      
        figure;     imshow(ob1);        title('endpoints')
        hold on;    plot(Cen(1),Cen(2),'*r')
        hold on;    plot(Pfc(1),Pfc(2),'*b')
        hold on;    text(10,20,num2str(n),'Color','r','BackgroundColor','g');
      
        figure; 
      imshow(im); hold on
      text(10,20,num2str(n),'Color','r','BackgroundColor','g');
    end
    
    if rotar == 0
        BBox = regionprops(esqueleto,'BoundingBox');
        ancho = BBox.BoundingBox(3);
        alto  = BBox.BoundingBox(4); 
        
        if ancho > alto
            rotado = 2;
        else
            rotar  = 2;      % Para comprobar si está invertido
        end
    end
    
    if rotar == 2 && (n == 1 || n == 2 || n == 7)
        switch n
            case 1
                if X_pf < -10
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

