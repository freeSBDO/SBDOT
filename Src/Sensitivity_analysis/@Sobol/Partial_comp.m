function [] = Partial_comp( obj )
% PARTIAL_COMP
% Computes Sobol partial indices
% See Table 2 formula (b)[Saltelli et. al. 2009]

if obj.partial ~= 0
    
    % Number of partial indices
    for i = 1:size( obj.M, 1 )
        
        % j corresponds to input which partial indices are computed
        j = find( obj.M(i,:) );
        
        if length(j) == 1 || obj.partial == 2
            
            x_si = obj.samp_A;
            x_si(:,j) = obj.samp_B(:,j);
            
            if isa(obj.func_obj,'Problem')
                y_si = obj.func_obj.Eval( x_si );
                obj.func_obj.x = [];
                obj.func_obj.y = [];
                obj.func_obj.g = [];
            else % Metamodel
                y_si = obj.func_obj.Predict( x_si );
            end
            
            % formula (b) of ref
            s_i(i) = mean( obj.y_B .* (y_si - obj.y_A) );
            
            if length(j) > 1 &&  s_i(i)~=0 % Higher order computation
                s_i(i) = s_i(i) - sum( s_i(j) ); % Remove first order influence
            end
            
        end
        
    end
    
    % Sobol partial indice
    obj.s_i = s_i / obj.y_var;
    
end

end

