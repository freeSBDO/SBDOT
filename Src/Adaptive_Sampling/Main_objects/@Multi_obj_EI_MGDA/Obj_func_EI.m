function [ EI_val, grad_EI ] = Obj_func_EI( obj, x_test )
%EI_UNCONSTRAINED
% Compute the Expected Improvement value for unconstrained case at x_test

% Prediction value and error at test point
for i = 1 : obj.m_y
    
    [ y_pred, MSE_pred ] = obj.meta_y(i,:).Predict( x_test );
    
    EI_val(:,i) = -stk_sampcrit_ei_eval(y_pred, sqrt(abs( MSE_pred )), obj.y_ref_temp(i));
    
end

grad_EI=[];
% old synthax for gradient but it was not working
% grad_EI(:,i) = -(1./(2*s_obj_2)) .* ...
%   ( EI(:,i) - ff .* CDF_gaussian(ff) ) .* ( grad_s' ) + ( grad_y' ) ./ s_obj ;

end

