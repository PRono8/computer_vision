function ob = ver_seguimientoContorno_isa(im)

im = im (3:end-3,3:end-3); % Quitar extremos de la imagen
ob = [];                   % Objeto segmentado 

global coor;
global coorc;
global sentido;

sentido = 1;    % Explorar en ambos senrtidos +-90º de la dirección 
                % gradiente

% Coordenadas de vecinos con respecto al punto de seguimiento.
coor  = [-1 0; -1 -1; 0 -1; 1 -1; 1 0; 1 1; 0 1; -1 1];

% Coordenadas de vecinos 
coorc = coor + 2; %

% Calculo del modulo y dirección del gradiente (operador sobel 3x3)
m = [-1 -2 -1; 0 0 0; 1 2 1];
imgx = conv2(double(im),double(m));       % Gradiente horizontal
imgy = conv2(double(im),double(m'));      % Gradiente vertical
img  = (abs(imgx)+abs(imgy));             % Módulo gradiente
img  = img/(max(max(img)));               % Módulo gradiente normalizado
ima  = atan2(imgy,imgx);                  % Dirección gradiente (radianes)

figure, imshow(img,[]); % Mostrar imagen del modulo del gradiente
hold on

[y,x] = ginput(1); % Seleccionar primer punto

f = round(x(1)); 
c = round(y(1));

% Seleccionar el punto de gradiente máximo en una ventana un entorno
% de 41x41 respecto al punto elegido
busqueda = img(f-20:f+20,c-20:c+20);
[df,dc] = find(busqueda == max(max(busqueda)));

f = f+df(1)-21; % Fila de punto de comienzo
c = c+dc(1)-21; % Columna del punto de comienzo

% Marcar punto inical
plot(c,f,'*');
plot(c,f,'o');

siguiente = 0;
fin = 0;

ob1f = f;          % Contendrá las filas del contorno segmentado 
ob1c = c;          % Contendrá las columnas del contorno segmentado
ob1n = img(f,c);   % Contendrá el gradiente del contorno segmentado

sentido = 1;  
cambio  = 0; 

while not(fin)  % Mientras se añadan puntos al contorno
    
    % Detectar cambio de sentido (contorno no cerrado)
    if (sentido == -1 & cambio == 0)
        f = ob1f;
        c = ob1c;
        cambio = 1;
        img (f,c) = ob1n; 
    end
    
    % Añade punto al contorno
    ob = [ob;f,c];
  
    niveles = img(f-1:f+1,c-1:c+1); % Gradiente de los 8 vecinos
    angulos = ima(f-1:f+1,c-1:c+1); % Dirección gradiente de los 8 vecinos
    
    % Busca el mejor candidato si los hay, fin = 1 si no los hay
    [incf, incc, fin] = nuevopunto(niveles,angulos);
    
    angulosn = mod(round(((angulos+pi)/(2*pi))*8),8); 
    dircont(1)  = angulosn(2,2);
    dircont(2)  = mod(((angulosn(2,2)-4)+8),8);
    
    img(f,c) = -1;  % Borra el gradiente del punto incorporado
    
    for k = 1:2     % Borra el gradiente de los puntos a +-90º 
                    % del punto incorporado.
        incx = coor(dircont(k)+1,1);
        incy = coor(dircont(k)+1,2);
        img(f+incx,c+incy) = -1;       
    end
    
    imc(f,c,:) = [0 1 0];  % Permite ver pixel en verde 
    
    % Punto incorporado al contorno
    f = f + incf;
    c = c + incc;
    siguiente = img(f,c);

    plot(c,f,'g.');
    drawnow
end

function [incf,incc,fin] = nuevopunto(niveles,angulos)

global coor;
global coorc;
global sentido;
    
    % Diferencia en gradiente y angulo en los 8 vecinos
    dn = abs(niveles-niveles(2,2));
    da = abs(cos(angulos)-cos(angulos(2,2)));

    angulosn = mod(round(((angulos+pi)/(2*pi))*8),8);
    
    % Posibles cadidados
    d(1)  = mod(((angulosn(2,2)+2*sentido)+8),8);
    d(2)  = mod(((d(1)-1)+8),8);
    d(3)  = mod(((d(1)+1)+8),8);

    for k = 1:3
        x = coorc(d(k)+1,1);
        y = coorc(d(k)+1,2);
        dgr(k) = dn(x,y);
        gr(k) = niveles(x,y);
        dan(k) = da(x,y);
    end

    
    candidatos = find(dgr<0.5  &  dan < pi/4 & gr >= 0.01); %& dan < pi/10
    
    n = [];
    for k = 1:numel(candidatos)
      n(k) = niveles(coorc(d(candidatos(k))+1,1),coorc(d(candidatos(k))+1,2));
    end
    

    if isempty(n)
        if (sentido == -1)
            fin = 1;
            incf = 0;
            incc = 0;
        else
            sentido = -1;
            fin = 0;
            incf = 0;
            incc = 0;
        end
    else
        [m,in] = max(n);
        in = candidatos(in); 
        incf = coor(d(in)+1,1);
        incc = coor(d(in)+1,2);
        fin = 0;
    end
    
    





