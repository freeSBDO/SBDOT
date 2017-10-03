function [ EHVI ] = Obj_func_EHVI( obj, x_test )
%OBJ_FUNC_EHVI 
%   Objective function for local optimization of EHVI

for i = 1 : obj.m_y
    
    [ y_pred(:,i), MSE_pred(:,i) ] = obj.meta_y(i,:).Predict( x_test );
    
end

EHVI = -stk_sampcrit_ehvi_eval(y_pred, sqrt(abs( MSE_pred )), obj.y_pareto_temp, obj.y_ref_temp);



end

