function [corr_mat, f_mat, zero_mat] = Corrlinear ( obj, diff_mat, theta )
% CORRLINEAR 
%   Linear radial function
%   - diff_mat is the matrix of squared manhattan distance
%   - theta is the correlation length parameter
%
%   - corr_mat is the correlation matrix
%   - f_mat is the polynomial matrix
%   - zero mat is the zero matrix
%   Those variables are used in the system to solve for obtaining RBF parameters
%

dist_theta = obj.Norm_theta( diff_mat, theta) ;

corr_mat = dist_theta;

f_mat = ones(obj.prob.n_x,1);

zero_mat = 0;

end

