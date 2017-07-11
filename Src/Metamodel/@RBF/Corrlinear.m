function [corr_mat, f_mat, zero_mat] = Corrlinear ( obj, diff_mat, theta )
% CORRLINEAR Linear radial function

dist_theta = obj.Norm_theta( diff_mat, theta) ;

corr_mat = dist_theta;

f_mat = ones(obj.prob.n_x,1);

zero_mat = 0;

end

