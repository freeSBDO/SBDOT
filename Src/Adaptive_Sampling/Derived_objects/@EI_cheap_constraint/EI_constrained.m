function [ EI_val, cons ] = EI_constrained( obj, x_test )
% EI_CONSTRAINED
%   Detailed explanation goes here
% Compute the Expected Improvement (EI1) 
% and the Probability of feasibility (EI2) value
% for constrained case at x_test

% Prediction value and error at test point
if isequal(obj.meta_type,@Q_kriging)
    n_test = size(x_test,1);
    [ y_pred, MSE_pred ] = obj.meta_y.Predict( x_test,repmat(obj.QV_val,n_test,1) );
    
    for i = 1 : obj.m_g
        [g_pred(:,i), MSE_g_pred(:,i) ] = obj.meta_g(i,:).Predict(x_test,repmat(obj.QV_val,n_test,1));
    end
else
    
    [ y_pred, MSE_pred ] = obj.meta_y.Predict( x_test );
    
    for i = 1 : obj.m_g
        [g_pred(:,i), MSE_g_pred(:,i) ] = obj.meta_g(i,:).Predict(x_test);
    end
end

EI1 = stk_sampcrit_ei_eval(y_pred, sqrt(abs( MSE_pred )), obj.y_min);

EI2 = stk_distrib_normal_cdf ( 0 , g_pred , sqrt(abs( MSE_g_pred )));
EI2 = prod( EI2, 2);


EI_val = [-EI1, -EI2];
cons = feval( obj.func_cheap, x_test ); 

end

