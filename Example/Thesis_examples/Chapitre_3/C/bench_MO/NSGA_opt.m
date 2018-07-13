clear all
close all
clc

for i = 1 : 20
    
    % Set random seed for reproductibility
    rng(i)
    
    % Define problem structure
    m_x = 2;    % Number of parameters
    m_y = 2;    % Number of objectives
    m_g = 0;    % Number of constraint
    lb = [0 0]; % Lower bound
    ub = [2 2]; % Upper bound
   
    % Instantiate optimization object
    nsga = NSGA_2('MO_convex_nsga',lb,ub,2,'n_pop',50,'max_gen',100,'display',true);
    
    pareto_final = Pareto_points( nsga.y(:,[1 2]) );

    spread_meas(i,:) = Spread_PF(pareto_final);
    spacing_meas(i,:) = Spacing_PF(pareto_final);
    hyp_meas(i,:) = stk_dominatedhv (pareto_final, [10 10]);   
    nbr_pareto(i,:) = size(pareto_final,1);
    
end

save('NSGA_results','spread_meas','spacing_meas','hyp_meas','nbr_pareto')
