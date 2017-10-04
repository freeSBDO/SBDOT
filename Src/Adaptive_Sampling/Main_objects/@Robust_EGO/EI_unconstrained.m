function [ EI_val ] = EI_unconstrained( obj, x_test )
%EI_UNCONSTRAINED
% Compute the Expected Improvement value for unconstrained case at x_test

% Prediction value and error at test point and robustness measure computation
[ y_rob, mse_y_rob ] = obj.Eval_rob_meas(x_test);

EI_val = -stk_sampcrit_ei_eval(y_rob, sqrt(abs( mse_y_rob )), obj.y_min);

end

