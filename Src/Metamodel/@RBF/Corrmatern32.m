function [corr_mat, f_mat, zero_mat] = Corrmatern32( obj, diff_mat, theta )
%CORRMATERN32 Matérn 3/2 radial function

dist_theta = obj.Norm_theta( diff_mat, theta) ;

corr_mat = (1 + sqrt(3) * dist_theta) .* exp( - (sqrt(3) * dist_theta) ) ;

f_mat = [];

zero_mat = [];

end

