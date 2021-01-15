function [squares,num_squares] = find_squares(image)

    %% Parameters
    open = 1000;        % Elimite small objects
    min_area = 10000;   % Elimite small objects
    u_max = 0.75;       % Maximum threshold 
    u_min = 0.25;        % Minimum threshold
    
    display1 = 0;
    display2 = 0;
    display3 = 0;

    %% Preprocessed

    % Binarization using the Otsu method (adaptative)
    ImGRay = 255-rgb2gray(image);
    Ibw = imbinarize(ImGRay,'adaptive','Sensitivity',0.41);

    %% Image processing
    % Fill in the holes
    Ifill = imfill(Ibw,'holes');

    % Elimite small objects
    Iarea = bwareaopen(Ifill,open);


    % Label connected regions
    Iprocessed= bwlabel(Iarea);

    % DISPLAY
    if(display1 == 1)
        figure('NumberTitle', 'off', 'Name', 'Preprocessed');
        subplot(1,5,1)
        imshow(image);
        title('Original image');
        
        subplot(1,5,2)
        imshow(Ibw)
        title('Binarized Image')
        
        subplot(1,5,3)
        imshow(Ifill)
        title('Fill image')
        
        subplot(1,5,4)
        imshow(Iarea)
        title('Image without small objects')
        
        subplot(1,5,5)
        imshow(Iprocessed,[])
        colormap(gca,[0,0,0;colorcube])
        title('Connected regions')
    end
    
    %% Identification

    % Binarized, filled with convex image and its area
    prop_im1 = regionprops(Iprocessed,'Image','ConvexImage','Area');

    % DISPLAY
    if(display2 == 1)
        % Show the signature of each object
        figure('NumberTitle', 'off', 'Name', 'Signatures');
        cont = 1;   % Auxiliary variables to display
    end   
    
    num_squares = 0;  % Auxiliary variables to count number of sudokus

    square = [];
    IndSquare = [];
    aux_display = [];
    for k = 1:numel(prop_im1)
        
        % Elimite small areas
        if (prop_im1(k).Area > min_area)
            aux_display = [aux_display k];
            % Calculation of the normalized signature
            [sig_ang,sig_val] = signature(prop_im1(k).ConvexImage);

            % Calculation of maximums:
            up_cut = find(sig_val >= u_max);
            sz = size(up_cut)-1;
            n_maximum = 1;
            for i=1:sz(1)
                if((up_cut(i+1) - up_cut(i)) > 10)
                    n_maximum = n_maximum + 1;
                end
            end   

            % Calculation of minimums:
            bottom_cut = find(sig_val <= u_min);
            sz = size(bottom_cut)-1;
            n_minimum = 1;
            for i=1:sz(1)
                if((bottom_cut(i+1) - bottom_cut(i)) > 10)
                    n_minimum = n_minimum + 1;
                end
            end  
            
            % If it has 4 minimum and 5 maximum it is a square and it is saved
            if(n_maximum == 5 && n_minimum == 4)
                IndSquare(num_squares+1) = k;
                num_squares = num_squares+1;
            end
        end
    end
    
    % DISPLAY
    if(length(aux_display) > 0 && display2 == 1)
        for i=1:length(aux_display)
            % Show the process
            subplot(length(aux_display),3,cont)
            imshow(prop_im1(aux_display(i)).Image);
            title('Region');
            subplot(length(aux_display),3,cont+1)
            imshow(prop_im1(aux_display(i)).ConvexImage);
            title('Convex image');
            subplot(length(aux_display),3,cont+2)
            % Show the signature
                % Calculation of the normalized signature
                [sig_ang,sig_val] = signature(prop_im1(aux_display(i)).ConvexImage);

                % Calculation of maximums:
                up_cut = find(sig_val >= u_max);
                sz = size(up_cut)-1;
                n_maximum = 1;
                for i=1:sz(1)
                    if((up_cut(i+1) - up_cut(i)) > 10)
                        n_maximum = n_maximum + 1;
                    end
                end   

                % Calculation of minimums:
                bottom_cut = find(sig_val <= u_min);
                sz = size(bottom_cut)-1;
                n_minimum = 1;
                for i=1:sz(1)
                    if((bottom_cut(i+1) - bottom_cut(i)) > 10)
                        n_minimum = n_minimum + 1;
                    end
                end  
            plot(sig_ang,sig_val);
            title(sprintf('Signature: Nmax = %d y Nmin = %d', n_maximum,n_minimum));
            cont=cont+3;  
        end
    end

    %% Squares extraction
    for k = 1:num_squares
        % The square region of the original is segmented (Just for display)        
        ImSquare = (Iprocessed == IndSquare(k));
        ImSudoku(:,:,1) = double(image(:,:,1)) .* (ImSquare);
        ImSudoku(:,:,2) = double(image(:,:,2)) .* (ImSquare);
        ImSudoku(:,:,3) = double(image(:,:,3)) .* (ImSquare);
        ImSudoku = ImSudoku/255;
        ImSudoku = 1-abs(ImSudoku);

        % The square region of the binarized is segmented
        ImSudokub(:,:,1) = double(Ibw(:,:)) .* (ImSquare);

        % They rotate        
        ImH = hough(ImSudokub);
        p = houghpeaks(ImH,1);
        ang = p(:,2);

        % Wrap angle
        if(ang >= 170)
            ang = ang - 180;
        elseif(ang >= 90)
            ang = ang - 90;
        elseif(ang > 80)
            ang = ang - 90;
        end
        ImR  = imrotate(ImSudoku,ang);
        ImRb = imrotate(ImSudokub,ang);


        % Extraction
        [rows, columns] = find(ImRb);
        row1 = min(rows);
        row2 = max(rows);
        col1 = min(columns);
        col2 = max(columns);
        Sudoku = ImR(row1:row2, col1:col2); % Crop image.

        st1 = string("squares.Image");
        st2 = string(k);
        st3 = string(" = Sudoku;");
        st = strcat(st1,st2,st3);
        eval(st);

        % DISPLAY
        if(display3 == 1)
            figure('NumberTitle', 'off', 'Name', 'Result');
            subplot(1,4,1)
            imshow(ImSudoku)
            title('Sudoku segmented');

            subplot(1,4,2)
            imshow(ImR)
            title('Sudoku rotate');

            subplot(1,4,3)
            imshow(ImRb)
            title('Sudoku rotate and binarized');

            subplot(1,4,4)
            imshow(Sudoku)
            title('Extracted');    
        end
    end
end
