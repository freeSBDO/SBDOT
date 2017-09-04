function [ x_norm ] = Rand_gauss( n, m, mu, sigma )
%RAND_GAUSS Summary of this function goes here
%   Detailed explanation goes here

x = randn( n, m );
x_norm = bsxfun( @plus, bsxfun( @times, x, sigma ), mu );
    
end

