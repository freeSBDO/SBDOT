function [ EI_val, grad_EI ] = Obj_func_EI( obj, x_test )

    %EI_UNCONSTRAINED
    % Compute the Expected Improvement value for unconstrained case at x_test

    
    % Prediction value and error at test poin
    EI_val = zeros(size(x_test,1),prod(obj.prob.m_t));
    
    for i = 1 : prod(obj.prob.m_t)

        [ y_pred, MSE_pred ] = obj.meta_y.Predict( x_test, repmat(i, size(x_test, 1), 1) );

        EI_val(:,i) = -stk_sampcrit_ei_eval(y_pred, sqrt(abs( MSE_pred )), obj.y_ref_temp(i));

    end

    grad_EI=[];

end

