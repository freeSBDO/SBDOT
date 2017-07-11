function [corr_mat, f_mat, zero_mat] = Corrcubic( obj, diff_mat, theta )
%CORRCUBIC Cubic radial function

dist_theta = obj.Norm_theta( diff_mat, theta) ;

corr_mat = dist_theta .^ 3 ;

f_mat = [ ones(obj.prob.n_x,1), obj.x_train ];

zero_mat = zeros( obj.prob.m_x + 1 );

end

