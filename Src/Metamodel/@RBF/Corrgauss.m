function [corr_mat, f_mat, zero_mat] = Corrgauss( obj, diff_mat, theta )
%CORRGAUSS Summary of this function goes here

dist_theta = obj.Norm_theta( diff_mat, theta) ;

corr_mat = exp( - (dist_theta .^2) ) ;

f_mat = [];

zero_mat = [];

end

