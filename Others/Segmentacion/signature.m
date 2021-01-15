function [angle,value] = signature(imb)

    % Returns the signature of a binary object
    ims = bwperim(imb);                    % Gets the contour pixels
    [x,y] = find (ims);                    % Get the coordinates
    mx = mean(x);                          % Get the centroid
    my = mean(y);   
    distance = sqrt((x-mx).^2+(y-my).^2);  % Distance to centroid of contour points
    angle = atan2(y-my,x-mx);              % Angle of the contour point with respect to the centroid
    [angle,sequence] = sort(angle);        % Sort distance by angle
    s = distance(sequence);                % Signature

    % Normalization: Scaling Immunity
    s = s-min(s);                              
    s = s/max(s);

    % First angle -> furthest point: Immunity to rotation
    maximum = find(s == 1);
    sz = size(s);
    sr = circshift(s,[(sz(1)-maximum) 0]);

    % Resulting signature:
    angle = angle+pi;
    value = sr;
end

