function [corr_mat, f_mat, zero_mat] = Corrmultiquadric( obj, diff_mat, theta )
% CORRMULTIQUADRIC
%   Multiquadric radial function 
%   - diff_mat is the matrix of squared manhattan distance
%   - theta is the correlation length parameter
%
%   - corr_mat is the correlation matrix
%   - f_mat is the polynomial matrix
%   - zero mat is the zero matrix
%   Those variables are used in the system to solve for obtaining RBF parameters
%

theta_squared = 10.^(theta);

dist_theta(:,:) = sum( bsxfun( @plus, diff_mat, 1./theta_squared ), 2 );

corr_mat = sqrt( dist_theta ) ;

f_mat = ones(obj.prob.n_x,1);

zero_mat = 0 ;

end

