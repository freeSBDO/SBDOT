function [] = Find_min_value( obj )
% FIND_MIN_VALUE
% Find the actual minimum value of the optimization problem in the already evaluated points

if obj.m_g>=1 %Constrained objective function
    
    obj.y_min = min( obj.prob.y( ...
        all( obj.prob.g(:,obj.g_ind) <= 0 , 2 ) , obj.y_ind...
                               ) ); % check feasibility
    if isempty(obj.y_min) 
        
        % if there is no feasible point, min_y is the maximum function value
        obj.y_min = max( obj.prob.y( :, obj.y_ind ) );   
        
    end
    
else %Unconstrained objective
    
    % min_y is directly the min value
    obj.y_min = min( obj.prob.y( :, obj.y_ind ) ); 
    
end

% minimum location
obj.loc_min = find( obj.prob.y( :, obj.y_ind ) == obj.y_min , 1 ); 
% x value of the minimum
obj.x_min = obj.prob.x( obj.loc_min , : ); 

if obj.m_g >= 1
    
    % g value of the minimum
    obj.g_min = obj.prob.g( obj.loc_min , obj.g_ind ); 
    
end

% Update history
obj.hist.y_min = [ obj.hist.y_min ; obj.y_min ];
obj.hist.x_min = [ obj.hist.x_min ; obj.x_min ];
if obj.m_g>=1
    obj.hist.g_min = [ obj.hist.g_min ; obj.g_min ];
end

end

