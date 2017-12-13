function [ y, g ] = Camel_constrained( x )
% CAMEL_CONSTRAINED 
%   for constrained optimization benchmark
% lb = [-2 -2]; ub = [2 2]

y = (4 - 2.1 *( x(:,1).^2 ) + ( x(:,1).^4 )/3) .* ( x(:,1).^2 ) ...
    + x(:,1) .* x(:,2) ...
    + (-4 + 4.*( x(:,2).^2 )).*( x(:,2).^2 );

g = 1.5 - (1.5*x(:,2) - cos(31*x(:,2))/6).^2 - x(:,1);

end

