clear all
close all
clc

% Set random seed for reproductibility
rng(1)

% Define problem structure
n_x = 2;      % Number of parameters
m_y = 1;      % Number of objectives
m_g = 1;      % Number of constraint
lb = [-5 0];  % Lower bound 
ub = [10 15]; % Upper bound 

% Create Problem object with optionnal parallel input as true
prob = Problem( 'Branin', n_x, m_y, m_g, lb, ub , 'parallel', true);

% Evaluate the model on 20 points created with LHS
prob.Get_design( 20 ,'LHS' )

% Instantiate optimization object
EGO = Expected_improvement( prob, 1, [], @Kriging, ...
    'corr', 'corrmatern52', 'iter_max',50 );

% Launch optimization 
EGO.Opt();

% Plot metamodel at end and optimum
EGO.meta_y.Plot( [1,2], [] );
hold on
plot3(EGO.x_min(:,1),EGO.x_min(:,2),EGO.y_min,'ro','MarkerFaceColor','r')

