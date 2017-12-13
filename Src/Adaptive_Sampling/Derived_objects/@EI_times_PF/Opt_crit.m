function [] = Opt_crit( obj )
% OPT_CRIT
% Select the new point to evaluate

obj.Find_min_value(); % Find actual minimum value

Initial_point = Unscale_data( rand( 1, obj.prob.m_x ),...
    obj.options_optim.LBounds, obj.options_optim.UBounds);

if obj.m_g >= 1
    % constrained
    [obj.x_new, EI] = cmaes( @obj.EI_constrained,...
        Initial_point, [], obj.options_optim);
else
    % unconstrained
    [obj.x_new, EI] = cmaes( @obj.EI_unconstrained,...
        Initial_point, [], obj.options_optim);
end
obj.EI_val = -EI;

end

