function [] = Opt_crit( obj )
%OPT_CRIT Main method
% Select the new point to evaluate

Initial_point = Unscale_data( rand( 1, obj.prob.m_x ),...
    obj.options_optim.LBounds, obj.options_optim.UBounds);

           
[obj.x_new,obj.error_value] = cmaes( @obj.Error_crit,...
    Initial_point, [], obj.options_optim);

end

