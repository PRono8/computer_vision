function [MSudoku] = get_numbers(square)

        fila = 1;
        columna = 1;
        
        rotado = 0; 
        rotar = 0;                      % Se inicializa a 0 para q compruebe si hay q rotar
        
        MSudoku   = zeros(9);           % Matriz del Sudoku, con ceros en casillas vacías
        Mrotacion = zeros(9);           % Matriz de comprobación, para verficar los num en caso de estar rotada la imagen
        
        if(num_squares == 81)           % Miro si están todas las casillas
            for i=1:num_squares         % Por cada casilla
                if(mod(i,9)==0)         % Por cada fila
                    columna = 1;
                    fila = fila+1;
                end
                
                [numero,im] = funcion_Jorge(square(i).Image);
                
                if(numero == 0)                                 % Casilla vacía
                    MSudoku(fila,columna) = 0;                  % Guardo cero en Sudoku
%                     Mrotacion(fila,columna) = 0;                % Guardo cero para indicar valor seguro
                else
                    [num,rotado] = Num_Identification(im, rotar, 0);    % Sino, llamo a función
                    
                     MSudoku(fila,columna) = num;               % Guardo en matriz Sudoku
                     
                     switch rotado 
                         case 0
                             if num == 5 || num == 6 || num == 9
                                Mrotacion(fila,columna) = 1;    % Se guarda como dudoso
                             else
                                Mrotacion(fila,columna) = 0;    % Se guarda como seguro
                             end
                             
                         case 1
                             switch rotar
                                 case 0
                                     rotar = 1;
                                 case 2
                                     rotar = 4;
                             end
                                    
                         case 2
                             rotar = 2;
                             i = i-1;
                             columna = columna-1;               % Para que vuelva a hacer ese número
                         case 3
                             if rotar == 2
                                 rotar = 5;
                                 i = i-1;
                                 columna = columna-1;
                             elseif rotar == 0
                                 rotar = 3;
                                 [MSudoku] = Control_rotado(i,square, Mrotacion, MSudoku);
                                 % Revisar los núm anteriores
                             else
                                 warning('Sale invertido cuando no debe')
                             end
                     end
                    
                columna = columna+1;                            % Siguiente columna
                end
            end
        else
            error('No se detectan todas las casillas correctamente');
        end
end

function [MSudoku] = Control_rotado(n, square, Mrotacion, MSudoku)
    for i=1:n
       fila = floor(i/9);
       columna = mod(i,9);
       
       if Mrotacion(fila,columna)==1
           [~,im] = funcion_Jorge(square(i).Image);
           [num,~] = Num_Identification(im, 3, 0);
           MSudoku(fila,columna) = num;
       end
    end 
end






