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
m_g = 0;
m_y = 1;
lb = 0.1; ub = 0.99;
n_x = 4; n_eval = 1000;
func_str = 'test_ego_unconstrained';

% Create Problem object with optionnal parallel input as true
prob = Q_problem( func_str, t, m_x, m_y, m_g, m_t, lb, ub , 'parallel', true );

% Evaluate the model on 4 points per level created with SLHS method
prob.Get_design( n_x ,'SLHS', 'maximin_type', 'Monte_Carlo', 'n_iter', 1000 );

EGO = Q_expected_improvement( prob, 1, [], @Q_kriging, 'corr', 'Q_Gauss', 'iter_max', 50 );

EGO.Opt();
