clear all
close all
clc

% Set random seed for reproductibility
rng(1)

% Define problem structure
m_x = 2;
m_y = 1;
m_g = 1;
lb = [-5 0];
ub = [10 15];

% Create Problem object with optionnal parallel input as true
prob = Problem( 'Branin', m_x, m_y, m_g, lb, ub , 'parallel', true);

% Evaluate the model on 20 points created with LHS
prob.Get_design( 20 ,'LHS' )

% Optional parameters for criterion optimization
options_optim.Restarts = 0;

% MSE optimization
obj = Error_prediction(prob, 1, [], @Kriging ,'iter_max',10,'crit_type','MSE','options_optim',options_optim);

% Figure

figure
hold on
plot(prob.x(1:20,1),prob.x(1:20,2),'bo','MarkerFaceColor','b','MarkerSize',8)
plot(prob.x(21:end,1),prob.x(21:end,2),'ro','MarkerFaceColor','r','MarkerSize',8)
xlabel('$x_1$','interpreter','latex')
ylabel('$x_2$','interpreter','latex')
axis([-5 10 0 15])
box on
hold off