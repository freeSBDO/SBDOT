function [ EI_val ] = EI_unconstrained( obj, x_test )
%EI_UNCONSTRAINED
% Compute the Expected Improvement value for unconstrained case at x_test

cheap_cons = feval( obj.func_cheap, x_test ); 

% Prediction value and error at test point
if isequal(obj.meta_type,@Q_kriging)
    n_test = size(x_test,1);
    [ y_pred, MSE_pred ] = obj.meta_y.Predict( x_test,repmat(obj.QV_val,n_test,1) );
else
    [ y_pred, MSE_pred ] = obj.meta_y.Predict( x_test );
end
EI_val = -stk_sampcrit_ei_eval(y_pred, sqrt(abs( MSE_pred )), obj.y_min);
% Cheap constraint
EI_val( any( cheap_cons > 0, 2 ) , : ) = nan( size( sum( any(cheap_cons<0,2) , 1 ) ) );
end

