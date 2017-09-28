function y_obj=Obj_func_nsga(obj,x_test)
% OBJ_FUNC_NSGA Objective function for nsga optimization
% Prediction value and error at test point

y_obj = zeros(size(x_test,1),prod(obj.prob.m_t));

for i=1:prod(obj.prob.m_t)
    
    y_obj(:,i) = obj.meta_y.Predict(x_test, repmat(i,size(x_test,1),1));
    
end

end
