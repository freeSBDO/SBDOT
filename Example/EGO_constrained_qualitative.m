clear all
close all
clc

% Set random seed for reproductibility
rng(1)

% 1D
% Define problem structure
t = {[1;2;3]};
m_t = 3;
m_x = 1;
m_g = 1;
m_y = 1;
lb = 0.01; ub = 0.99;
n_x = [3,3,3];
func_str = 'test_ego_constrained';

% Create Problem object with optionnal parallel input as true
prob = Q_problem( func_str, t, m_x, m_y, m_g, m_t, lb, ub , 'parallel', true );

% Evaluate the model on 3 points per level created with SLHS method
prob.Get_design( n_x ,'SLHS', 'maximin_type', 'Monte_Carlo', 'n_iter', 1000 );

EGO = Q_expected_improvement( prob, 1, 1, @Q_kriging, 'iter_max', 50 );

EGO.Opt();