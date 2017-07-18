function [y, g] = emse_2(x)
    %emse_2
    % x is a ... by 2 matrix of input points
    %   variable 1 (in column 1) is set between [0 1] or [-1 1] usually
    %	variable 2 (in column 2) is qualitative; levels : [1, 2, 3]
    %
    % y is a ... by 2 matrix of objective values
    %   emse_2 has 2 objective function
    %   objective 1 (in column 1) correspond to emse_1 response
    %   objective 2 (in column 2) is another the objective function from Esperan Padonou
    
    q=x(:,2);
    x=x(:,1);
    y1 = (-1).^(q-1).*cos(pi*(7-0.2*round(0.9./q)).*x/2);
    y2 = (-2.5+4.75*q-1.25*q.^2).*(-1).^(q-1).*cos(pi*(7-0.2*round(0.9./q)).*x/2);
    y = [y1, y2];
    g = abs(cos(2*pi.*x)).^q;
    
end
