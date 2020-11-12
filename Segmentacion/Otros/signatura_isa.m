function [angulo,valor] = signatura_isa (imb);

%Devuelve la signatura de un obejto binario

ims = bwperim(imb);                     % Obtiene los pixels del contorno
[x,y] = find (ims);                     % Obtiene las coordenadas
mx = mean(x);                           % Calcula el centroide
my = mean(y);   
distancia = sqrt((x-mx).^2+(y-my).^2);  % Distancia al centroide de los puntos del contorno
angulo = atan2(y-my,x-mx);              % �ngulo del punto del contorno con respecto al centroide
[angulo,orden] = sort(angulo);          % Ordenar distancia seg�n el �ngulo
s = distancia(orden);                   % Signatura

% Normalizaci�n: Inmunidad al escalado
s = s-min(s);                              
s = s/max(s);

% Primer �ngulo punto m�s alejado: Inmunidad a la rotaci�n
maximo = find(s == 1);
tam = size(s);
tam = tam(1);

sr = circshift(s,[(tam-maximo) 0]);

% s1 = s(maximo:tam);
% s2 = s(1:(tam-1));
%sr = [s1;s2];

% Signatura resultante:
angulo = angulo+pi;
valor = sr;





