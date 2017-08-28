function [] = Find_min_value( obj )
% FIND_MIN_VALUE
% Find the actual minimum value of the optimization problem in the already evaluated points

if obj.m_g>=1 %Constrained objective function
    
    g_mat = cell2mat(obj.prob.g');
    y_mat = cell2mat(obj.prob.y');
    
    obj.y_min = min( y_mat( all( g_mat(:,obj.g_ind) <= 0 , 2 ) , obj.y_ind ) ); % check feasibility
    
    if isempty(obj.y_min) 
        
        % if there is no feasible point, min_y is the maximum function value
        obj.y_min = max( y_mat( :, obj.y_ind ) );   
        
    end
    
else %Unconstrained objective
    
    % min_y is directly the min value
    y_mat = cell2mat(obj.prob.y');
    obj.y_min = min( y_mat( :, obj.y_ind ) );
    
end

% minimum location
obj.loc_min = find( y_mat == obj.y_min , 1 ); 
% x value of the minimum
x_temp = cell2mat(obj.prob.x');
obj.x_min = x_temp( obj.loc_min , : ); 

if obj.m_g >= 1
    
    % g value of the minimum
    obj.g_min = g_mat( obj.loc_min , obj.g_ind ); 
    obj.hist.g_min = [ obj.hist.g_min ; obj.g_min ];
    
end
    
obj.hist.y_min = [ obj.hist.y_min ; obj.y_min ];
obj.hist.x_min = [ obj.hist.x_min ; obj.x_min ];

end