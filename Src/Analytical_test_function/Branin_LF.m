function [ y, g ] = Branin_LF( x )
% Modified Branin test function for multifidelity : low fidelity version
%
% x is a ... by 2 matrix of input points
%   variable 1 (in column 1) is set between [-5 10]
%	variable 2 (in column 2) is set between [0 15]
%
% y is a ... by 1 matrix of objective values
%   branin test has 1 objective function
%
% g is a ... by 1 matrix of constraint values
%   branin test has 1 constraint function
%
% Ref: A. Forrester, D. A. Sobester, and A. Keane, Engineering Design via
% Surrogate Modelling: A Practical Guide. John Wiley & Sons, 2008. (p. 196)

X1 = x(:,1);
X2 = x(:,2);

a = 1;
b = 5.1/(4*pi^2);
c = 5/pi;
d = 6;
e = 10;
ff = 1/(8*pi);

y = a .* ( X2 - b .* X1.^2 + c .* X1 - d ) .^ 2 + ...
    e .* ( 1 - ff ) .* cos( X1 ) +...
    e + ...
    5 .* ( ( X1 + 5 ) ./ 15 );

y = (0.9 + 0.1*rand(size(y))) .* y; % low fidelity

g = 0.2 - ( (( X1 + 5 ) ./ 15) .* (X2 ./15) );

end
