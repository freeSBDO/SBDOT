function [ y ] = Robust_1D( x )
% ROBUST_1D
%

y = 5 - ...
    0.7 * exp( -(x-0.2).^2 ./ 0.04 ) - ...
    2*exp( -(x-0.5).^2./1 ) - ...
    exp( -(x-0.8).^2 ./ 0.01);

end

