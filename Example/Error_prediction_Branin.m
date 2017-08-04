clear all
close all
clc

% Set random seed for reproductibility
rng(1)

% Define problem structure
n_x = 2;
m_y = 1;
m_g = 1;
lb = [-5 0];
ub = [10 15];

% Create Problem object with optionnal parallel input as true
prob = Problem( 'Branin', n_x, m_y, m_g, lb, ub , 'parallel', true);

% Evaluate the model on 20 points created with LHS
prob.Get_design( 20 ,'LHS' )

%%
options_optim.DispModulo = 0;
options_optim.Restarts = 0;

obj = Error_prediction(prob, 1, [], @Kriging ,'iter_max',10,'crit_type','MSE','options_optim',options_optim);

figure
hold on
plot(prob.x(1:20,1),prob.x(1:20,2),'bo')
plot(prob.x(21:end,1),prob.x(21:end,2),'ko')