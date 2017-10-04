function [ EI_val, cons ] = EI_constrained( obj, x_test )
% EI_CONSTRAINED
% Compute the Expected Improvement (EI1) 
% and the Probability of feasibility (EI2) value
% for constrained case at x_test

% Prediction value and error at test point and robustness measure computation
[ y_rob, mse_y_rob, g_rob, mse_g_rob ] = obj.Eval_rob_meas(x_test);

EI1 = stk_sampcrit_ei_eval(y_rob, sqrt(abs( mse_y_rob )), obj.y_min);

EI2 = stk_distrib_normal_cdf ( 0 , g_rob , sqrt(abs( mse_g_rob )));
EI2 = prod( EI2, 2);


EI_val = [-EI1, -EI2];
cons=[]; 

end

