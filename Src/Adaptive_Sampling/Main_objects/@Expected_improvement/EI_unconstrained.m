function [ EI_val ] = EI_unconstrained( obj, x_test )
%EI_UNCONSTRAINED
% Compute the Expected Improvement value for unconstrained case at x_test

% Prediction value and error at test point
if isequal(obj.meta_type,@Q_kriging)
    
    n_test = size(x_test,1);
    [ y_pred, MSE_pred ] = obj.meta_y.Predict( x_test,repmat(obj.QV_val,n_test,1) );
    
else
    
    [ y_pred, MSE_pred ] = obj.meta_y.Predict( x_test );
    
end

switch obj.criterion
    case 'EI'
        EI_val = -stk_sampcrit_ei_eval(y_pred,...
            sqrt(abs( MSE_pred )), obj.y_min);
    case 'PI'
        EI_val = -stk_distrib_normal_cdf (obj.y_min ,...
            y_pred , sqrt(abs( MSE_pred )));
end

end

