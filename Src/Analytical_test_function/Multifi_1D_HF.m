function y_HF = Multifi_1D_HF( x )
% Test function for multifidelity: high fidelity
%
% x is a ... by 1 matrix of input points
%   variable 1 (in column 1) is set between [0 1]
%
% y_HF is a ... by 1 matrix of high fidelity objective values
%
% Ref: A. Forrester, D. A. Sobester, and A. Keane, Engineering Design via
% Surrogate Modelling: A Practical Guide. John Wiley & Sons, 2008. (p. 173)

y_HF = (( 6*x - 2 ).^2) .* sin( 12*x - 4 );

end
