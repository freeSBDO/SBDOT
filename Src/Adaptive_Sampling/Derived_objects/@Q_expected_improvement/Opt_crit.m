function [] = Opt_crit( obj )
%OPT_CRIT Main method
% Select the new point to evaluate

    obj.QV_val = 1;
    EI_temp = 0;
    
    for i = 1:prod(obj.prob.m_t)
        
        obj.Find_min_value(); % Find actual minimum value

        if obj.m_g >= 1

            % constrained optimization
            % Multi-objective optimization (choosen way for constraint handling )
            nsga = NSGA_2( @obj.EI_constrained,...
                obj.options_optim.lb, obj.options_optim.ub, obj.prob.m_x );

            % Find the point that maximize EI times Pf in the Pareto front
            prod_fitness = prod( nsga.y ,2 );
            prod_fitness_best = find( prod_fitness == max( prod_fitness ), 1 );
            
            if obj.QV_val == 1

                obj.x_new = [nsga.x( prod_fitness_best, : ), obj.QV_val];
                obj.EI_val = prod_fitness( prod_fitness_best );
                EI_temp = obj.EI_val;

            elseif prod_fitness( prod_fitness_best ) > EI_temp

                obj.x_new = [nsga.x( prod_fitness_best, : ), obj.QV_val];
                obj.EI_val = prod_fitness( prod_fitness_best );
                EI_temp = obj.EI_val;

            end

        else

            % unconstrained optimization    
            Initial_point = Unscale_data( rand( 1, obj.prob.m_x ),...
            obj.options_optim.LBounds, obj.options_optim.UBounds);

            [x_new, EI] = cmaes( @obj.EI_unconstrained,...
            Initial_point, [], obj.options_optim);

            if obj.QV_val == 1

                EI_temp = -EI;
                obj.EI_val = -EI; 
                obj.x_new = [x_new, obj.QV_val];

            elseif -EI>EI_temp  

                EI_temp = -EI;
                obj.EI_val = -EI; 
                obj.x_new = [x_new, obj.QV_val];

            end

        end
        
        obj.QV_val = obj.QV_val + 1;
        
    end
    
end

