%% Lectura del fichero
% Leemos el archivo con nuestra imagen
img = imread('Sudoku.jpg');
% La pasamos a escala de grises
imGray = rgb2gray(img);
% Recortamos la imagen para trabajar sobre esta parte
% imGray = imrotate(imGray,-2.8);
% imR = imcrop(imGray);
imR = imGray;
%% Resolución mediante Sobel
% Elegir cual de los resultados nos resulta más cómodo
% Ejecutamos la función edge
im1 = edge(imR,'sobel',0.01);
% figure
% subplot(121)
% imshow(im1)
% title('Resultado con función edge(sobel)')
% Ahora lo realizamos mediante la función imfilter
imagenSobelH = imfilter(imR,fspecial('sobel'),'replicate');
imagenSobelH = double(imagenSobelH);
imagenSobelV = imfilter(imR,fspecial('sobel')','replicate');
imagenSobelV = double(imagenSobelV);
im2 = sqrt((imagenSobelH.^2)+(imagenSobelV.^2));
% subplot(122)
% imshow(im2);
% title('Resultado con función imfilter(fspecial(sobel))')
%% Resolución mediante crecimiento de regiones (~)
% Buscamos los lugares
[n,m] = size(imGray);
semilla = zeros(n,m);
semilla(10,9) = 1;
semilla(104,14) = 1;
semilla(70,38) = 1;
semilla(70,38) = 1;
resultado = regiongrow(imGray,semilla,50);
% imshow(resultado);
% Invertimos el resultado
resultadoNot = ~resultado;
% imshow(resultadoNot)
% rn = regionprops(resultadoNot,'all');   


%% Extracción de la imagen directamente (ordenador)
prueba = ~im1;
% imshow(prueba)
r = regionprops(prueba,'all');
Areas = [r.Area].';
Box = zeros(82,4);
for i = 1:length(r)
    Box(i,:) = r(i).BoundingBox;
end
cuadros = zeros(1,81);
p = 1;
for i = 1:length(Areas)
%     if Areas(i) > lapso1*lapso2*0.5 && Areas(i) < lapso1*lapso2
    if Areas(i) > 700 && Areas(i) < 900  
        cuadros(p) = i;
        p = p + 1;
    end
end
% Buscar forma de ordenar las posiciones
for j = 1 : length(cuadros)
    if cuadros(j) ~= 0
        i = cuadros(j);
        recorte = r(i).Image;
%         imshow(recorte);
    end
end


%% Búsqueda de cada casilla de forma teórica (cualquiera)
% Obtenemos las medidas de cada cuadro sabiendo sobre lo que trabajamos
[n,m] = size(imGray);
lapso1 = n/9; % Podemos considerar es un cuadrado y generalizar
lapso2 = m/9;
x_ini = 5;
y = 5;
% Recortamos cada cuadrado
for i = 1:9
    x = x_ini; % Reseteamos para cada fila
    for j = 1:9
        recorte = imcrop(imGray,[x y lapso2 lapso1]);
%         imshow(recorte)
        x = x + lapso2;
        % Posición para anidar la identificación del número
    end
    y = y + lapso1;
end
% im_recorte = imcrop(imR,[11 11 26 26]); % [xmin ymin width height]