function [] = Find_min_value( obj )
% FIND_MIN_VALUE
% Find the actual minimum value of the optimization problem in the already evaluated points

% min_y is directly the min value
[obj.y_min, obj.loc_min] = min ( max( obj.prob.y( :, obj.y_ind ), [], 2 ) );

% x value of the minimum
obj.x_min = obj.prob.x( obj.loc_min , : ); 
    
obj.hist.y_min = [ obj.hist.y_min ; obj.y_min ];
obj.hist.x_min = [ obj.hist.x_min ; obj.x_min ];

end

