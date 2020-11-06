function sig = signatura_isa (imb);

%Devuelve la signatura de un obejto binario

ims = bwperim(imb);                     % Obtiene los pixels del contorno
[x,y] = find (ims);                     % Obtiene las coordenadas
mx = mean(x);                           % Calcula el centroide
my = mean(y);   
distancia = sqrt((x-mx).^2+(y-my).^2);  % Distancia al centroide de los puntos del contorno
angulo = atan2(y-my,x-mx);              % Ángulo del punto del contorno con respecto al centroide
[angulo,orden] = sort(angulo);          % Ordenar distancia según el ángulo
s = distancia(orden);                   % Signatura
s = s/max(s);                           % Signatura normalizada

sig = [angulo+pi,s];


