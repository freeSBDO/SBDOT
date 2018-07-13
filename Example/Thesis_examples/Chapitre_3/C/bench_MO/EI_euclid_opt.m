clear all
close all
clc

save_plot = true;
s = hgexport('readstyle','manuscrit');
s.Format = 'png';

for i = 1 : 20
    
    % Set random seed for reproductibility
    rng(i)
    
    % Define problem structure
    m_x = 2;    % Number of parameters
    m_y = 2;    % Number of objectives
    m_g = 0;    % Number of constraint
    lb = [0 0]; % Lower bound
    ub = [2 2]; % Upper bound
    
    % Create Problem object with optionnal parallel input as true
    prob = Problem( 'MO_convex', m_x, m_y, m_g, lb, ub , 'parallel', true);
    
    % Evaluate the model on 20 points created with LHS
    prob.Get_design( 20 ,'LHS' )
    
    % Instantiate optimization object
    EGO = Multi_obj_EHVI( prob, [1 2], [], @Kriging, 5, ...
        'fcall_max',40 ,'criterion', 'EI_euclid' );
    
    pareto_final = Pareto_points( prob.y(:,[1 2]) );

    spread_meas(i,:) = Spread_PF(pareto_final);
    spacing_meas(i,:) = Spacing_PF(pareto_final);
    hyp_meas(i,:) = stk_dominatedhv (pareto_final, [10 10]);     
    nbr_pareto(i,:) = size(pareto_final,1);
        
end

save('EI_euclid_results','spread_meas','spacing_meas','hyp_meas','nbr_pareto')
