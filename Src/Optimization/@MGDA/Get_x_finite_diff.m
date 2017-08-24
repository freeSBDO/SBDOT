function x_finite_diff = Get_x_finite_diff( obj, x_eval )
% Create the input matrix to evaluate, for finite difference calculation

H = diag( obj.finite_diff_step ); % finite diff vector to diag matrix
x_finite_diff = bsxfun( @plus, x_eval, H ); % forward finite difference point

end