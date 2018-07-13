clear all
close all
clc

% Set random seed for reproductibility
rng(1)

% Define problem structure
m_x = 1; % Number of parameters
m_y = 1; % Number of objectives
m_g = 0; % Number of constraints
lb = 0;  % Lower bound
ub = 10; % Upper bound

% Create Problem object 
prob1 = Problem( @(x)x.*sin(x), m_x, m_y, m_g, lb, ub , 'parallel', true);
prob2 = Problem( @(x)x.*sin(x), m_x, m_y, m_g, lb, ub , 'parallel', true);
prob3 = Problem( @(x)x.*sin(x), m_x, m_y, m_g, lb, ub , 'parallel', true);


% Evaluate the model on 20 points created with LHS
prob1.Get_design( 3 ,'LHS' )
prob2.Get_design( 6 ,'LHS' )
prob3.Get_design( 12 ,'LHS' )


% Kriging
krig1 = Kriging ( prob1 , 1 , [] );
krig2 = Kriging ( prob2 , 1 , [] );
krig3 = Kriging ( prob3 , 1 , [] );

% Variance prediction
x_pred = linspace(0,10,200)';

[~,s_pred1] = krig1.Predict( x_pred );
[~,s_pred2] = krig2.Predict( x_pred );
[~,s_pred3] = krig3.Predict( x_pred );

% Figure
figure
hold on
plot( x_pred, s_pred1, 'k-')
plot( x_pred, s_pred2, 'b-')
plot( x_pred, s_pred3, 'r-')
box on
xlabel('$x$','interpreter','latex')
ylabel('${\hat{\sigma}_{\hat y}}^2$','interpreter','latex')
legend({'$n = 3$','$n = 6$','$n = 12$'},'interpreter','latex')
hold off
