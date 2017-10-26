function [] = Total_comp( obj )
% TOTAL_COMP
% Computes Sobol total indices
% See Table 2 formula (f)[Saltelli et. al. 2009]

if obj.total == 1
    
    for i = 1:obj.m
        
        x_stot = obj.samp_A;
        x_stot(:,i) = obj.samp_B(:,i);
        
        if isa(obj.func_obj,'Problem')
            y_stot = obj.func_obj.Eval( x_stot );
            obj.func_obj.x = [];
            obj.func_obj.y = [];
            obj.func_obj.g = [];
        else % Metamodel
            y_stot = obj.func_obj.Predict( x_stot );
        end
        
        % formula (f) of ref
        s_tot(i) = mean( (obj.y_A - y_stot) .^ 2 );
        
    end
    
    obj.s_tot = s_tot / ( 2*  obj.y_var );
    
end

end

