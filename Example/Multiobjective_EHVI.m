clear all
close all
clc

rng(1)

% Define problem structure
n_x = 2;
m_y = 2;
m_g = 0;
lb = [0 0]; 
ub = [2 2]; 

% Create Problem object with optionnal parallel input as true
prob = Problem( 'MO_convex', n_x, m_y, m_g, lb, ub , 'parallel', true);

% Evaluate the model on 20 points created with LHS
prob.Get_design( 20 ,'LHS' )

pareto_init = Pareto_points( prob.y(:,[1 2]) );

EGO = Multi_obj_EHVI( prob, [1 2], [], @Kriging, Inf, ...
    'corr', 'corrmatern52', 'fcall_max',40 );

pareto_final = Pareto_points( prob.y(:,[1 2]) );

% Plot
figure
hold on
plot(pareto_init(:,1),pareto_init(:,2),'ro')
plot(pareto_final(:,1),pareto_final(:,2),'bo')
legend('Initial data','Optimization result')
xlabel('Objective 1')
ylabel('Objective 2')
hold off