function f = emse_1(x)
    %emse_1
    % x is a ... by 2 matrix of input points
    %   variable 1 (in column 1) is set between [0 1] or [-1 1] usually
    %	variable 2 (in column 2) is qualitative; levels : [1, 2, 3]
    %
    % f is a ... by 1 matrix of objective values
    %   emse_1 has 1 objective function
    %
    % Ref : 2012, Zhou et al.
    
    q=x(:,2);
    x=x(:,1);
    f=(-1).^(q-1).*cos(pi*(7-0.2*round(0.9./q)).*x/2);

end
