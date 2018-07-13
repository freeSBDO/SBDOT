clear all
close all
clc

% Set random seed for reproductibility
rng(1)

% Define problem structure
m_x = 2; % Number of parameters
m_y = 1; % Number of objectives
m_g = 1; % Number of constraints
lb = [-5 0];  % Lower bound
ub = [10 15]; % Upper bound

% Create Problem object with optionnal parallel input as true
prob_krig = Problem( 'Branin', m_x, m_y, m_g, lb, ub , 'parallel', true);

% Evaluate the model on 20 points created with LHS
prob_krig.Get_design( 20 ,'LHS' );

%%
options_optim.DispModulo = 0;
options_optim.Restarts = 0;

% Adaptive sampling
obj1 = Error_prediction(prob_krig, 1, [], @Kriging ,'iter_max',10,'crit_type','IMSE','options_optim',options_optim);

figure
hold on
plot(prob_krig.x(1:20,1),prob_krig.x(1:20,2),'bo','MarkerFaceColor','b','MarkerSize',8)
plot(prob_krig.x(21:end,1),prob_krig.x(21:end,2),'ro','MarkerFaceColor','r','MarkerSize',8)
xlabel('$x_1$','interpreter','latex')
ylabel('$x_2$','interpreter','latex')
axis([-5 10 0 15])
box on
