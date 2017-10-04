function [corr_mat, f_mat, zero_mat] = Corrmatern32( obj, diff_mat, theta )
% CORRMATERN32 
%   Matérn 3/2 radial function
%   - diff_mat is the matrix of squared manhattan distance
%   - theta is the correlation length parameter
%
%   - corr_mat is the correlation matrix
%   - f_mat is the polynomial matrix
%   - zero mat is the zero matrix
%   Those variables are used in the system to solve for obtaining RBF parameters
%

dist_theta = obj.Norm_theta( diff_mat, theta) ;

corr_mat = (1 + sqrt(3) * dist_theta) .* exp( - (sqrt(3) * dist_theta) ) ;

f_mat = [];

zero_mat = [];

end

