function [ EI_val ] = EI_unconstrained( obj, x_test )
 %EI_UNCONSTRAINED
% Compute the Expected Improvement value for unconstrained case at x_test

% Prediction value and error at test point
[ y_pred, MSE_pred ] = obj.meta_y.Predict( x_test );

EI_val = -stk_sampcrit_ei_eval(y_pred, sqrt(abs( MSE_pred )), obj.y_min);

end

