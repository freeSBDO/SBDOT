function y_obj=Obj_func_nsga(obj,x_test)
% OBJ_FUNC_NSGA Objective function for nsga optimization
% Prediction value and error at test point

for i=1:obj.m_y
    
    y_obj(:,i) = obj.meta_y(i,:).Predict(x_test);
    
end

end
