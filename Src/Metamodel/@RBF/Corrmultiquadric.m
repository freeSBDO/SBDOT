function [corr_mat, f_mat, zero_mat] = Corrmultiquadric( obj, diff_mat, theta )
% CORRMULTIQUADRIC Multiquadric radial function 

theta_squared = 10.^(theta);

dist_theta(:,:) = sum( bsxfun( @plus, diff_mat, 1./theta_squared ), 2 );

corr_mat = sqrt( dist_theta ) ;

f_mat = ones(obj.prob.n_x,1);

zero_mat = 0 ;

end

