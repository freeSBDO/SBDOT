function [y, g] = test_ego_constrained(x)
    %test_ego_constrained
    % x is a ... by 2 matrix of input points
    %   variable 1 (in column 1) is set between [0 1] or [-1 1] usually
    %	variable 2 (in column 2) is qualitative; levels : [1, 2, 3]
    %
    % y is a ... by 1 matrix of objective values
    %
    % g is a ... by 1 matrix of constraint values
    
    q=x(:,2);
    x=x(:,1);
    y = (-2.5+4.75*q-1.25*q.^2).*(-1).^(q-1).*cos(pi*(7-0.2*round(0.9./q)).*x/2) - 50.*exp(-1./x).*exp(1./(x-1));
    g = zeros(size(x,2),1);
    g(q==1) = cos( 0.1+x(q==1).*(pi/0.3) );
    g(q==2) = cos(x(q==2).*(7*pi/2));
    g(q==3) = cos(x(q==3).*(pi/0.3));
    g = g';
    
end
