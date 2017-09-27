function y = test_ego_unconstrained(x)
    %test_ego_unconstrained
    % x is a ... by 2 matrix of input points
    %   variable 1 (in column 1) is set between [0 1] or [-1 1] usually
    %	variable 2 (in column 2) is qualitative; levels : [1, 2, 3]
    %
    % y is a ... by 1 matrix of objective values
    
    q=x(:,2);
    x=x(:,1);
    y = (-2.5+4.75*q-1.25*q.^2).*(-1).^(q-1).*cos(pi*(7-0.2*round(0.9./q)).*x/2) - 50.*exp(-1./x).*exp(1./(x-1));
end
