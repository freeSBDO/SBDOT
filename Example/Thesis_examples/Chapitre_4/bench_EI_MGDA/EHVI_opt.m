clear all
close all
clc

for i = 1 : 20
    
    % Graine de l'aléa
    rng(i)
    
    % Define problem structure
    m_x = 2;    % Nombre de paramètres
    m_y = 2;    % Nombre d'objectifs
    m_g = 0;    % Nombre de contraintes
    lb = [0 0]; % Borne inférieure des paramètres
    ub = [2 2]; % Borne supérieure des paramètres
    
    % Création du problème
    prob = Problem( 'MO_convex', m_x, m_y, m_g, lb, ub , 'parallel', true);
    
    % Création d'un plan d'expérience de type OLHS et
    % évaluation des points
    prob.Get_design( 20 ,'LHS' )
    
    % Lancement de l'optimisation par critère EHVI
    EGO = Multi_obj_EHVI( prob, [1 2], [], @Kriging, 5, ...
        'fcall_max',40 ,'criterion', 'EHVI' );
    
    % Extraction du front de Pareto parmi les points évalués
    pareto_final = Pareto_points( prob.y(:,[1 2]) );
    
    % Calcul de mesures sur la qualité du front
    spread_meas(i,:) = Spread_PF(pareto_final);
    spacing_meas(i,:) = Spacing_PF(pareto_final);
    hyp_meas(i,:) = stk_dominatedhv (pareto_final, [10 10]);     
    nbr_pareto(i,:) = size(pareto_final,1);
    min_y(i,:) = EGO.y_min;
    
end

save('EHVI_results','spread_meas','spacing_meas','hyp_meas','nbr_pareto','min_y')
