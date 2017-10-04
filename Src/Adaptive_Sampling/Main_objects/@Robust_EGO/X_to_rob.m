function [ x_rob ] = X_to_rob( obj, x)
% X_TO_ROB
% Prepare x for mse evaluation
% Environmental variables are set to their nominal values

for i = 1:obj.prob.m_x
    
    switch obj.unc_type{i}
        
        case {'uni','gauss'}
            
            if obj.env_lab(i)
                x_rob(:,i) = (obj.prob.lb(i) + obj.prob.ub(i))/2;
            else
                x_rob(:,i) = x(:,i);
            end
            
        case {'det'}
            
            x_rob(:,i) = x(:,i);
            
    end
    
end

end

