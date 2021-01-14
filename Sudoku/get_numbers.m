function [MSudoku] = get_numbers(square,num_squares)

        fila = 1;
        columna = 1;
        
        display1 = 0;
        display2 = 0;
        
        rotado = 0; 
        rotar = 0;                      % Se inicializa a 0 para q compruebe si hay q rotar
        
        MSudoku   = zeros(9);           % Matriz del Sudoku, con ceros en casillas vacías
        Mrotacion = zeros(9);           % Matriz de comprobación, para verficar los num en caso de estar rotada la imagen
        
        if(num_squares == 81)           % Miro si están todas las casillas
            for i=1:num_squares         % Por cada casilla
                
                
                [im,numero,area_total] = empty_squares_detection(square{i},display1);
                
                if(numero == 0)                                 % Casilla vacía
                    MSudoku(fila,columna) = 0;                  % Guardo cero en Sudoku
%                     Mrotacion(fila,columna) = 0;                % Guardo cero para indicar valor seguro
                else
                    [num,rotado] = Num_Identification(im, rotar, display2);    % Sino, llamo a función
                    
                     MSudoku(fila,columna) = num;               % Guardo en matriz Sudoku
                     %rotado = 1; % QUITAR!!!
                     switch rotado 
                         case 0
                             if num == 5 || num == 6 || num == 9 || num==7 || num==1
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
                                 warning('Ha entrado en Control_rotado');
                                 [MSudoku] = Control_rotado(i,square, Mrotacion, MSudoku,display1,display2);
                                 % Revisar los núm anteriores
                             else
                                 warning('Sale invertido cuando no debe')
                             end
                     end
%                 fila
%                 columna
%                 MSudoku
                
                
                end
                fila
                columna
                MSudoku
                if(mod(i,9)==0)         % Por cada fila
                    columna = 1;
                    fila = fila+1;
                else
                    columna = columna+1;
                end
            end
            
            if rotar ~= 1
                MSudoku = Giro_matriz(rotar, MSudoku);
            end
        else
            error('No se detectan todas las casillas correctamente');
        end
end

function [MSudoku] = Control_rotado(n, square, Mrotacion, MSudoku,display1,display2)
    fila = 1;
    columna = 1;
    for i=1:n
       if Mrotacion(fila,columna)==1
           [im,~,~] = empty_squares_detection(square{i},display1);
           [num,~] = Num_Identification(im, 3, display2);
           MSudoku(fila,columna) = num;
       end
       if(mod(i,9)==0)         % Por cada fila
            columna = 1;
            fila = fila+1;
        else
            columna = columna+1;
        end
    end 
end

function [MSudoku] = Giro_matriz(rotar, A)
    warning('Se gira la matriz...');
    switch rotar
        case 3      % Rotar 180º
           MSudoku = [fliplr(A(9,:)) ;fliplr(A(8,:)) ;fliplr(A(7,:)) ;fliplr(A(6,:)) ;fliplr(A(5,:)) ;fliplr(A(4,:)) ;fliplr(A(3,:)) ;fliplr(A(2,:)) ;fliplr(A(1,:)) ];

           
        case 4      % Rotar 90º
           MSudoku = [A(:,9)' ;A(:,8)' ;A(:,7)' ;A(:,6)' ;A(:,5)' ;A(:,4)' ;A(:,3)' ;A(:,2)' ;A(:,1)' ];
        case 5      % Rotar -90º
           MSudoku = [A(9,:)' ,A(8,:)' ,A(7,:)' ;A(6,:)' ,A(5,:)' ,A(4,:)' ;A(3,:)' ,A(2,:)' ,A(1,:)' ];
        otherwise
            warning('Entra en Giro_matriz erroneamente (rotar = 0||2)')
    end
end






