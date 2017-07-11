function [corr_mat, f_mat, zero_mat] = Corrinvmultiquadric( obj, diff_mat, theta )
%CORRINVMULTIQUADRIC Inverse multiquadric radial function

theta_squared = 10.^(theta);

dist_theta(:,:) = sum( bsxfun( @plus, diff_mat, 1./theta_squared ), 2 );

corr_mat = 1 ./ sqrt( dist_theta ) ;

f_mat = [];

zero_mat = [];

end

