function [corr_mat, f_mat, zero_mat] = Corrgauss( obj, diff_mat, theta )
% CORRGAUSS 
%   Gaussian radial function
%   - diff_mat is the matrix of squared manhattan distance
%   - theta is the correlation length parameter
%
%   - corr_mat is the correlation matrix
%   - f_mat is the polynomial matrix
%   - zero mat is the zero matrix
%   Those variables are used in the system to solve for obtaining RBF parameters
%

dist_theta = obj.Norm_theta( diff_mat, theta) ;

corr_mat = exp( - (dist_theta .^2) ) ;

f_mat = [];

zero_mat = [];

end

