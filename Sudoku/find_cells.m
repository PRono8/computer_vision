function [image_cell] = find_cells(img1)
%% Resolucion identificacion cuadriculas transformada de hough
%%Resolucion identificacion cuadriculas transformada de hough
%% Lectura del fichero
% Recortamos la imagen para trabajar sobre esta parte
sum=0;
for i=1:length(img1(:,1))
    for j=1:length(img1(1,:))
        sum=sum+img1(i,j);
    end
end
media_pixel=sum/(length(img1(:,1))*length(img1(1,:)));
imR = imbinarize(img1,'adaptive','ForegroundPolarity','dark','Sensitivity',0.58);

%% Resolución mediante Sobel
% Ahora lo realizamos mediante la función imfilter
imagenSobelH = imfilter(imR,fspecial('sobel'),'replicate');
imagenSobelH = double(imagenSobelH);
imagenSobelV = imfilter(imR,fspecial('sobel')','replicate');
imagenSobelV = double(imagenSobelV);
im2 = sqrt((imagenSobelH.^2)+(imagenSobelV.^2));
%% Mejora de imagen edge + sobel 
if length(imR(1,:))>=250
    se = strel('line',0.01*length(img1(:,1)),0);
    BW2 = imdilate(im2,se);
    se = strel('line',0.01*length(img1(:,1)),90);
    im2 = imdilate(BW2,se);
end


%% 
% img1Gray=rgb2gray(im2);
% img1BW=imbinarize(img1Gray);
% imgedge=edge(img1BW);

imgedge=im2;

%transformacion de hough
[H,T,R] = hough(imgedge);

%busqueda de peaks
P  = houghpeaks(H,24,'threshold',ceil(0.3*max(H(:)))); x = T(P(:,2)); y = R(P(:,1)); %plot(x,y,'s','color','white');


%busqueda de lineas
lines = houghlines(imgedge,T,R,P,'FillGap',600,'MinLength',0.8*length(img1(:,1)));
diagonales=[];
cont=1;
for i=1:length(lines)
    if abs(abs(lines(i).theta)-90)>=15 && abs(lines(i).theta)>=15   
        diagonales(cont)=i;
        cont=cont+1;
    end
end
cont2=0;

% if cont>1
    for i=1:length(diagonales)
        lines(diagonales(i)-cont2)=[];
        cont2=cont2+1;
    end
% end
%% 
clear lines_horizontal;
clear lines_vertical;

%Separar en Horizontales y verticales
contvertical=1;
conthorizontal=1;
for i=1:length(lines)
    if abs(lines(i).theta-0)<= 10 %vertical
        lines_vertical(contvertical)=lines(i);
        contvertical=contvertical+1;
    end
    if abs(abs(lines(i).theta) - 90)<=10 %horizontal
        lines_horizontal(conthorizontal)=lines(i);
        conthorizontal=conthorizontal+1;

    end    
end

%ordenar de menor a mayor horizontales y verticales

for i=1:length(lines_vertical)-1
    for j=1:length(lines_vertical)-1
    if lines_vertical(j).point1(1)>lines_vertical(j+1).point1(1)
        aux=lines_vertical(j);
        lines_vertical(j)=lines_vertical(j+1);
        lines_vertical(j+1)=aux;
    end
    end
end

for i=1:length(lines_horizontal)-1
    for j=1:length(lines_horizontal)-1
    if lines_horizontal(j).point1(2)>lines_horizontal(j+1).point1(2)
        aux=lines_horizontal(j);
        lines_horizontal(j)=lines_horizontal(j+1);
        lines_horizontal(j+1)=aux;
    end
    end
end

%Si no conseguimos detectar bordes (a veces pasa) los eliminamos sabiendo
%que son el primer  ultimo elemento dsps de ordenar
if length(lines_horizontal(:))==10
    lines_horizontal=lines_horizontal(2:length(lines_horizontal)-1);

end
if length(lines_vertical(:))==10
    lines_vertical=lines_vertical(2:length(lines_vertical)-1);
end
if length(lines_horizontal(:))==9
    lines_horizontal=lines_horizontal(1:length(lines_horizontal)-1);

end
if length(lines_vertical(:))==9
    lines_vertical=lines_vertical(1:length(lines_vertical)-1);
end


%%



max_len = 0;
xmin=1000;
xmax=0;
ymin=1000;
ymax=0;

for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];  

    %Determine the endpoints of the longest line segment   
    len = norm(lines(k).point1 - lines(k).point2);   
    if ( len > max_len)       
        max_len = len;       
        xy_long = xy;   
    end
    
    Pxmin=min([lines(k).point1(1),lines(k).point2(1)]);
    Pxmax=max([lines(k).point1(1),lines(k).point2(1)]);

    Pymin=min([lines(k).point1(2),lines(k).point2(2)]);
    Pymax=max([lines(k).point1(2),lines(k).point2(2)]);

    
    if (Pxmin<xmin)
        xmin=Pxmin;
    end
    if (Pxmax>xmax)
        xmax=Pxmax;
    end
    if (Pymin<ymin)
        ymin=Pymin;
    end
    if (Pymax>ymax)
        ymax=Pymax;    
    end
    
    
end

% Cálculo puntos de corte rectas
crossingpoints=zeros(length(lines_horizontal)*length(lines_vertical),2);
%crossingpoints=zeros((length(lines)/2)^2,2);

cont=1;



for i=1:length(lines_horizontal) %horizontales
    for j=1:length(lines_vertical) %verticales
    
    x1=lines_horizontal(i).point1(1);
    y1=lines_horizontal(i).point1(2);

    x2=lines_horizontal(i).point2(1);
    y2=lines_horizontal(i).point2(2);

 
    x3=lines_vertical(j).point1(1);
    y3=lines_vertical(j).point1(2);

    x4=lines_vertical(j).point2(1);
    y4=lines_vertical(j).point2(2);
    
    A=[y2-y1 , -(x2-x1);
    y4-y3, -(x4-x3)];

    B=[(y1*x1 - y1*x2) - (x1*y1 - x1*y2);
    (y3*x3 - y3*x4) - (y3*x3 - x3*y4)];

    x=A\B;

    crossingpoints(cont,:)=x;
    cont=cont+1;
    end
end





%% Generación vector imágenes de cuadrícula (ordena por filas)


if length(lines_horizontal)==8
xi=xmin;
yi=ymin;
n=81;
image_cell=cell(n,1);
contPoints=1;
for i=1:8
    %fila 1
    image_cell{i}=imR(yi:crossingpoints(contPoints,2),xi:crossingpoints(contPoints,1));

    xi=crossingpoints(contPoints,1);
    contPoints=contPoints+1;
end
i=i+1;
image_cell{i}=imR(yi:crossingpoints(contPoints-1,2),xi:xmax);

xi=xmin;
yi=crossingpoints(1,2);

for i=10:17
    %fila 2
    image_cell{i}=imR(yi:crossingpoints(contPoints,2),xi:crossingpoints(contPoints,1));

    xi=crossingpoints(contPoints,1);
    contPoints=contPoints+1;

end 
i=i+1;
image_cell{i}=imR(yi:crossingpoints(contPoints-1,2),xi:xmax);

xi=xmin;

yi=crossingpoints(9,2);

for i=19:26
    %fila 3
    image_cell{i}=imR(yi:crossingpoints(contPoints,2),xi:crossingpoints(contPoints,1));

    xi=crossingpoints(contPoints,1);
    contPoints=contPoints+1;

end 
i=i+1;
image_cell{i}=imR(yi:crossingpoints(contPoints-1,2),xi:xmax);

xi=xmin;

yi=crossingpoints(17,2);
for i=28:35
    %fila 4
    image_cell{i}=imR(yi:crossingpoints(contPoints,2),xi:crossingpoints(contPoints,1));

    xi=crossingpoints(contPoints,1);
    contPoints=contPoints+1;

end 
i=i+1;
image_cell{i}=imR(yi:crossingpoints(contPoints-1,2),xi:xmax);

xi=xmin;

yi=crossingpoints(25,2);
for i=37:44
    %fila 5
    image_cell{i}=imR(yi:crossingpoints(contPoints,2),xi:crossingpoints(contPoints,1));


    xi=crossingpoints(contPoints,1);
    contPoints=contPoints+1;

end 
i=i+1;
image_cell{i}=imR(yi:crossingpoints(contPoints-1,2),xi:xmax);

xi=xmin;

yi=crossingpoints(33,2);
for i=46:53
    %fila 6
    image_cell{i}=imR(yi:crossingpoints(contPoints,2),xi:crossingpoints(contPoints,1));


    xi=crossingpoints(contPoints,1);
    contPoints=contPoints+1;

end 
i=i+1;
image_cell{i}=imR(yi:crossingpoints(contPoints-1,2),xi:xmax);

xi=xmin;

yi=crossingpoints(41,2);

for i=55:62
    %fila 7
    image_cell{i}=imR(yi:crossingpoints(contPoints,2),xi:crossingpoints(contPoints,1));


    xi=crossingpoints(contPoints,1);
    contPoints=contPoints+1;

end 
i=i+1;
image_cell{i}=imR(yi:crossingpoints(contPoints-1,2),xi:xmax);

xi=xmin;

yi=crossingpoints(49,2);
for i=64:71
    %fila 8
    
    image_cell{i}=imR(yi:crossingpoints(contPoints,2),xi:crossingpoints(contPoints,1));


    xi=crossingpoints(contPoints,1);
    contPoints=contPoints+1;

end 
i=i+1;
image_cell{i}=imR(yi:crossingpoints(contPoints-1,2),xi:xmax);

xi=xmin;

yi=crossingpoints(57,2);
contPoints=contPoints-8;
for i=73:80
    %fila 9
    
    image_cell{i}=imR(yi:ymax,xi:crossingpoints(contPoints,1));


    xi=crossingpoints(contPoints,1);
    contPoints=contPoints+1;


end 
i=i+1;
image_cell{i}=imR(yi:ymax,xi:xmax);

end



end