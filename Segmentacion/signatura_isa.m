function sig = signatura_isa (imb);

%Devuelve la signatura de un obejto binario

ims = bwperim(imb);                     % Obtiene los pixels del contorno
[x,y] = find (ims);                     % Obtiene las coordenadas
mx = mean(x);                           % Calcula el centroide
my = mean(y);   
distancia = sqrt((x-mx).^2+(y-my).^2);  % Distancia al centroide de los puntos del contorno
angulo = atan2(y-my,x-mx);              % �ngulo del punto del contorno con respecto al centroide
[angulo,orden] = sort(angulo);          % Ordenar distancia seg�n el �ngulo
s = distancia(orden);                   % Signatura
s = s-min(s);                              
s = s/max(s);                           % Signatura normalizada


sig = [angulo+pi,s];


