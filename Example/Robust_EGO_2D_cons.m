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
prob.Get_design( 15 ,'LHS' )

% Robust EGO

% Define variables are environmental or not
robust_def.env_lab = [ 0 0 ];
% Define variables are correlated or not
robust_def.cor_lab = [ 0 0 ];
% Define variables are for photonic design or not
robust_def.phot_lab = [ 0 0 ];
% Define variables probability law
robust_def.unc_type = {'uni','uni'};
% Define variables variance
robust_def.unc_var=[ 2 0 ];
% Define robustness measure on objective
robust_def.meas_type_y = 'Mean_meas';
% Define robustness measure on constraint
robust_def.meas_type_g = 'Worstcase_meas';

% Optimization
EGO = Robust_EGO( prob, 1, 1, @Kriging, robust_def, 500, ...
    'corr', 'corrmatern52', 'iter_max',50 );