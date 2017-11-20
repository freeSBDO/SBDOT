%%% Optimize the output of a numerical model under some constraints (also
%%% generated by the same numerical model)
%%% The criterion used here is the Gutmann criterion

clear all
close all
clc

% Set random seed for reproductibility
rng(1)

% Define problem structure
m_x = 2;      % Number of parameters
m_y = 1;      % Number of objectives
m_g = 1;      % Number of constraint
lb = [-5 0];  % Lower bound 
ub = [10 15]; % Upper bound 

% Create Problem object with optionnal parallel input as true
prob = Problem( 'Branin', m_x, m_y, m_g, lb, ub , 'parallel', true);

% Get design
prob.Get_design( 20 ,'LHS' )

% Instantiate optimization object
obj = CORS_RBF(prob, 1, [], @RBF, 'fcall_max', 20);
% Launch optimization
obj.Opt();

% Plot metamodel and optimum at end
obj.meta_y.Plot( [1,2], [] );
hold on
plot3(obj.x_min(:,1),obj.x_min(:,2),obj.y_min,'ro','MarkerFaceColor','r')