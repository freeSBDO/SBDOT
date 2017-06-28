function C = hypersph2cart(x)
    % HYPERSPH2CART converts hyperspheric coordinates to cartesian
    % coordinates
    %
    %   Inputs:
    %       x hypershperic coordinates
    %
    %   Output:
    %       C cartesian coordinates
    %
    % Syntax :
    % C = hypersph2cart( x );
    
    [d, n] = size(x);
    r = x(1,:);
    C = zeros(d,n);
    sph = x(2:d,:);
    premult = r;

    for i = 1:(d-1)
        
        C(i,:) = premult .* cos(sph(i,:));
        premult = premult .* sin(sph(i,:));
        
    end

    C(d,:) = premult;
    
end


