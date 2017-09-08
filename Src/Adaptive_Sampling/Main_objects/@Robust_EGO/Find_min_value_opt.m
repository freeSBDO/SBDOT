function [] = Find_min_value_opt( obj )
% FIND_MIN_VALUE
% Find the actual minimum value of the optimization problem in the already evaluated points

Initial_point = Unscale_data( rand( 1, nnz(~obj.env_lab) ), ...
    obj.options_optim3.LBounds, obj.options_optim3.UBounds);

[ obj.x_min, obj.y_min ] = cmaes(@obj.Optim_meas, Initial_point, [], obj.options_optim3);

if obj.m_g >= 1
    [~,~,obj.g_min,~] = obj.Eval_rob_meas(obj.x_min);
end

obj.hist.y_min_opt = [ obj.hist.y_min_opt ; obj.y_min ];
obj.hist.x_min_opt = [ obj.hist.x_min_opt ; obj.x_min ];
if obj.m_g >= 1
    obj.hist.g_min_opt = [ obj.hist.g_min_opt ; obj.g_min ];
end

end

