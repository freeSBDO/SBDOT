function [corr_mat, f_mat, zero_mat] = Corrmatern52( obj, diff_mat, theta )
%CORRMATERN52 Matérn 5/2 radial function

dist_theta = obj.Norm_theta( diff_mat, theta) ;

corr_mat = (1 + sqrt(5) * dist_theta + (5/3) * (dist_theta.^2)) ...
    .* exp( - (sqrt(5) * dist_theta) ) ;

f_mat = [];

zero_mat = [];

end

