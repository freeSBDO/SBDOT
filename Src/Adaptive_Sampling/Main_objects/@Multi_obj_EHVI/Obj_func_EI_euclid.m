function [ EI_euclid ] = Obj_func_EI_euclid( obj, x_test )
%OBJ_FUNC_EHVI 
%   Objective function for local optimization of EI_euclid

for i = 1 : obj.m_y
    
    [ y_pred(:,i), MSE_pred(:,i) ] = obj.meta_y(i,:).Predict( x_test );
    
end

EI_euclid = -obj.EI_euclid(y_pred, sqrt(abs( MSE_pred )), obj.y_pareto_temp, obj.y_ref_temp);


