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

% Get design
prob.Get_design( 20 ,'LHS' )

% Optimizaion
obj = Gutmann_RBF(prob, 1, 1, @RBF, 'fcall_max', 20);
obj.Opt();

obj.meta_y.Plot( [1,2], [] );
hold on
plot3(obj.x_min(:,1),obj.x_min(:,2),obj.y_min,'ro','MarkerFaceColor','r')
