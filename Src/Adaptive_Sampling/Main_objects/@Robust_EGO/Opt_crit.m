function [] = Opt_crit( obj )
%OPT_CRIT Main method
% Select the new point to evaluate for adaptive sampling sequence

% Build CRN matrix
obj.Compute_CRN();
obj.Find_min_value_opt(); % Find actual minimum value on prediction
obj.Find_min_value_prob(); % Find actual minimum value on "training data"

if obj.m_g >= 1
    
    % constrained optimization
    % Multi-objective optimization (choosen way for constraint handling )
    nsga = NSGA_2( @obj.EI_constrained,...
        obj.lb_rob, obj.ub_rob, nnz(~obj.env_lab) );
    
    % Find the point that maximize EI times Pf in the Pareto front
    prod_fitness = prod( nsga.y ,2 );
    prod_fitness_best = find( prod_fitness == max( prod_fitness ), 1 );
    
    x_new_rob = nsga.x( prod_fitness_best, : );
    obj.EI_val = prod_fitness( prod_fitness_best );
    
else
    
    % unconstrained optimization    
    Initial_point = Unscale_data( rand( 1, nnz(~obj.env_lab) ),...
    obj.lb_rob, obj.ub_rob);

    [x_new_rob, EI] = cmaes( @obj.EI_unconstrained,...
    Initial_point, [], obj.options_optim1);

    obj.EI_val = -EI; 

end

% Select the value of environmental variable to evaluate
if any(obj.env_lab)
    
    Initial_point2 = Unscale_data( rand( 1, nnz(obj.env_lab) ), ...
        obj.options_optim2.LBounds, obj.options_optim2.UBounds);
    
    x_new_env = cmaes( @obj.Optim_env, ...
        Initial_point2, [], obj.options_optim2, x_new_rob);
    
    obj.x_new = [ x_new_rob x_new_env ] ;
    
else
    
    obj.x_new = x_new_rob;
    
end


end

