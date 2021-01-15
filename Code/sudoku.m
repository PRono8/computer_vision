function [MSudokus,num_MSudokus] = sudoku(image)

    % Find sudokus
    [ImSudokus,num_sudokus] = find_sudoku(image);
    
    % For each sudoku
    num_MSudokus = 0;
    
    MSudokus(1).Matrix = zeros(9); 
    
    for k=1%1:num_sudokus
        
        MSudoku = zeros(9,9);
        MaSudoku = zeros(9);
        
        % Función casillas (Marta y Jorge)
        %[squares,num_squares] = find_cells(ImSudokus(k).Image);
        img = imcomplement(ImSudokus(k).Image);
        squares = find_cells(img,1);
        
        num_squares = length(squares);
 
        % Gestionar error si num_squares != 81
        if(num_squares ~= 81)
            warning('Un Sudoku detectado incorrecto')
            continue
        end

        % Detectar números (Mario)
        MaSudoku = get_numbers(squares,num_squares);
        
        % Se guarda en la estructura
        MSudokus(k).Matrix = MaSudoku;
        
        MSudokus(k).SolveMatrix = sudoku_solver(MSudokus(k).Matrix);
        
        % Número de Sudokus analizados
        num_MSudokus = num_sudokus+1;
    end
    num_MSudokus = num_sudokus-1;
end


%% Función casillas (Marta y Jorge)
        % Dentro de la función: squares(x).Image y num_squares=81:
        % squares(1).Image  - squares(9).Image  -> Primera fila
        % squares(10).Image - squares(18).Image -> Segunda fila
        % squares(19).Image - squares(27).Image -> Tercera fila
        % Código:
        % squares(i).Image = casilla_i;


%% Detectar números (Mario)
%         %Dentro de la función:
%         fila = 1;
%         columna = 1;
%         % Control orientación vertical y horizontal
%         % ...
%         rotado = 0;
%         MCodigos = zeros(9);
%         % Si están todas las casillas
%         if(num_squares == 81)
%             % Por cada una:
%             for i=1:num_squares
%                 % Por cada fila
%                 if(mod(i,9)==0)
%                     columna = 1;
%                     fila = fila+1;
%                 end
%                 if(MCodigos == 1)
%                     continue
%                 end
%                 
%                 numero = funcion_Jorge(square(i).Image);
%                 
%                 if(numero == 0)
%                     MSudoku(fila,columna) = 0;
%                 else
%                     % square con imagen de la casilla
%                     [num,rotado] = detect_number(square(i).Image,rotado);
%                     
%                     if(rotado == 1)
%                         % Control orientación en función del número
%                         [MSudoku,MCodigos] = control_rot(MSudoku);
%                         i = 1;
%                     else
%                         MSudoku(fila,columna) = num;
%                     end
%                 columna = columna+1; % Siguiente columna
%             end
%         else
%             % Código de error
%         end
% 
% function MSudokuG = control_rot(MSudoku)
%     MSudokuG = MSudoku';
% 
% end
    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             % [A] = find_numbers(imGray);
%         figure
%         imshow(imR2);
%         imR = abs(1-imR2);
%         figure
%         imshow(imR)
%         im1 = edge(imR,'sobel',0.01);
%         figure
%         imshow(im1);
%         prueba = ~im1;
%         figure
%         imshow(prueba);
%         r = regionprops(prueba,'all');
%         Areas = [r.Area].';
%         Box = zeros(82,4);
%         for i = 1:length(r)
%             Box(i,:) = r(i).BoundingBox;
%         end
%         cuadros = zeros(1,81);
%         p = 1;
%         for i = 1:length(Areas)
%         %     if Areas(i) > lapso1*lapso2*0.5 && Areas(i) < lapso1*lapso2
%             if Areas(i) > 700 && Areas(i) < 900  
%                 cuadros(p) = i;
%                 p = p + 1;
%             end
%         end
%         % Buscar forma de ordenar las posiciones
%         for j = 1 : length(cuadros)
%             if cuadros(j) ~= 0
%                 i = cuadros(j);
%                 recorte = r(i).Image;
%         %         imshow(recorte);
%             end
%         end
%         
%     end    
%     
%     
% 
%     
%         %% BÃºsqueda de cada casilla de forma teÃ³rica (cualquiera)
%         % Obtenemos las medidas de cada cuadro sabiendo sobre lo que trabajamos
%         [n,m] = size(imGray);
%         lapso1 = n/9; % Podemos considerar es un cuadrado y generalizar
%         lapso2 = m/9;
%         x_ini = 0;
%         y = 0;
%         % Recortamos cada cuadrado
%         for i = 1:9
%             x = x_ini; % Reseteamos para cada fila
%             for j = 1:9
%                 
%                 recorte = imcrop(imGray,[x y lapso2 lapso1]);
%                 figure
%                 imshow(recorte)
%                 x = x + lapso2;
%                 % PosiciÃ³n para anidar la identificaciÃ³n del nÃºmero
%                 
%                 %%
%                 num = Num_Identification(recorte, 1);
%                 %A(i,j) = num;
%             end
%             y = y + lapso1;
%         end
%         % im_recorte = imcrop(imR,[11 11 26 26]); % [xmin ymin width height]
%         
%         %A
%     end