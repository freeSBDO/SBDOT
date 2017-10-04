function [] = Opt_crit( obj )
%OPT_CRIT Main method
% Select the new point to evaluate

obj.Find_min_value(); % Find actual minimum value

if obj.m_g >= 1
    
    % constrained optimization
    % Multi-objective optimization (choosen way for constraint handling )
    nsga = NSGA_2( @obj.EI_constrained,...
        obj.options_optim.lb, obj.options_optim.ub, obj.prob.m_x );
    
    % Find the point that maximize EI times Pf in the Pareto front
    prod_fitness = prod( nsga.y ,2 );
    cons_tol = all(nsga.g <= 0, 2); % for cheap constraint
    prod_fitness_best = find( prod_fitness == max( prod_fitness ) & cons_tol ...
        , 1 );
    
    obj.x_new = nsga.x( prod_fitness_best, : );
    obj.EI_val = prod_fitness( prod_fitness_best );
    
else
    
    % unconstrained optimization    
    Initial_point = (obj.options_optim.LBounds + obj.options_optim.UBounds)/2;

    [obj.x_new, EI] = cmaes( @obj.EI_unconstrained,...
    Initial_point, [], obj.options_optim);

    obj.EI_val = -EI; 

end

end

