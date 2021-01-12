function [squares2,empty,Area] = empty_squares_detection(squares,display)
    empty = [];
    
    im_cell = squares;
    
    prop = regionprops(squares,'Area','EulerNumber','ConvexImage','BoundingBox');
    max_area = max([prop.Area]);
    object = find([prop.Area] ==  max_area);

    box = prop(object).BoundingBox;
    margx = 0.2*max(box(3),box(4))/2;
    cell = imcrop(im_cell, [box(1)+margx, box(2)+margx, box(3)-2*margx, box(4)-2*margx]); % You can x, y, height and width for coord(k)
    

    cellc = imcomplement(cell);
    cellc = imclearborder(cellc,4);
    
    prop2 = regionprops(cellc,'Area','EulerNumber','Image','BoundingBox');
    if (~isempty(prop2))
        if(~isempty(prop2) && prop2(1).Area > 30)
            empty = 1;

            max_area = max([prop2.Area]);
            object = find([prop2.Area] ==  max_area);

            squares2 = prop2(object).Image;
            Area = prop2(1).Area;
        else
            empty = 0;
            Area = 0;
            squares2 = cellc;
        end
    else
        empty = 0;
        Area = 0;
        squares2 = cellc;
    end
    
    if(display == 1)
        figure
        subplot(1,4,1)
        imshow(squares);
        
        subplot(1,4,2)
        imshow(cell);
        
        subplot(1,4,3)
        imshow(cellc);
        
        subplot(1,4,4)
        imshow(squares2);
    end
end