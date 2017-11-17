function y_LF = Multifi_1D_LF( x )
% Test function for multifidelity: low fidelity
%
% x is a ... by 1 matrix of input points
%   variable 1 (in column 1) is set between [0 1]
%
% y_LF is a ... by 1 matrix of low fidelity objective values
%
% Ref: A. Forrester, D. A. Sobester, and A. Keane, Engineering Design via
% Surrogate Modelling: A Practical Guide. John Wiley & Sons, 2008. (p. 173)


A = 0.5;
B = 10;
C = 5;

ye_c = (( 6*x - 2 ).^2) .* sin( 12*x - 4 );
y_LF = A*ye_c + B*( x - 0.5 ) - C;

end
