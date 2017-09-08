function [] = Find_min_value_prob( obj )
% FIND_MIN_VALUE
% Find the actual minimum value of the optimization problem in the already evaluated points

[y_prob,~,g_prob,~] = obj.Eval_rob_meas(obj.prob.x(:,~obj.env_lab));

if obj.m_g>=1
    
    y_min_prob = min( y_prob( ...
        all( g_prob(:,obj.g_ind) <= 0 , 2 ) , :...
        ) );
    
else
    
    y_min_prob = min( y_prob );
    
end
    ind_min = find( y_prob == y_min_prob , 1 ); 

    x_min_prob = obj.prob.x( ind_min ,~obj.env_lab );

obj.hist.y_min_prob = [ obj.hist.y_min_prob ; y_min_prob ];
obj.hist.x_min_prob = [ obj.hist.x_min_prob ; x_min_prob ];

if obj.m_g >= 1
    g_min_prob = g_prob( ind_min, obj.g_ind );
    obj.hist.g_min_prob = [ obj.hist.g_min_prob ; g_min_prob ];
end

end

