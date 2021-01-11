for i  = 1:9
    for k = i:10:i+30
        
        im = imread(strcat('Num_', num2str(k),'.jpeg'));
        
        im_i = imrotate(im,180);
        im_r = imrotate(im,90);
        im_r2 = imrotate(im,-90);
        
        [n,rotado] = Num_Identification(im, 0, 0);
        [n_i,rotado_i] = Num_Identification(im_i, 2, 0);
        [n_r,rotado_r] = Num_Identification(im_r, 0, 0);
        [n_r2,rotado_r2] = Num_Identification(im_r2, 0, 0);
        
%         numero = k
%         numero_correcto = n
%         rotacion_1 = rotado
%         numero_inverso  = n_i
%         rotacion_3 = rotado_i
%         numero_tumbado  = n_r
%         rotacion_2 = rotado_r
%         numero_tumbado2 = n_r2
%         rotacion_2 = rotado_r2
        
        [k 0 ;n rotado ;n_r rotado_r ;n_r2 rotado_r2; n_i rotado_i ]
        
        pause;
        clc;
    end
    pause;
end

% Comprobar orientación:
% 1 : X_pf > un pequeño límite
% 2 : Dist del pfc /puede salir como 5
% 3 : Detecta 5
% 4 : Detecta 4
% 5 : Detecta 5, pero puede ser 3 al revés
% 6 : Detecta 9
% 7 : X_pf + ó -
% 8 : Detecta 8
% 9 : Detecta 6

% Nos sirven: 1 2 7
% Seguros: 1 2 3 4 7 8
% Dudosos: 5 6 9
% *Tumbado no se reconoce ninguno, pero es solo una iteración