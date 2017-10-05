%%% Optimize the output of a numerical model when inputs parameters have
%%% some uncertainties

clear all
close all
clc

% Set random seed for reproductibility
rng(1)

% Define problem structure
n_x = 1; % Number of parameters
m_y = 1; % Number of objectives
m_g = 0; % Number of constraint
lb = 0;  % Lower bound 
ub = 1;  % Upper bound 

% Create Problem object with optionnal parallel input as true
prob = Problem( 'Robust_1D', n_x, m_y, m_g, lb, ub , 'parallel', true);

% Evaluate the model on 20 points created with LHS
prob.Get_design( 4 ,'LHS' )

% Robust EGO

% Define variables are environmental or not
robust_def.env_lab = [ 0 ];      
% Define variables are correlated or not
robust_def.cor_lab = [ 0 ];
% Define variables are for photonic design or not
robust_def.phot_lab = [ 0 ];
% Define variables probability law
robust_def.unc_type = {'uni'};
% Define variables variance
robust_def.unc_var=[ 0.2 ];
% Define robustness measure on objective
robust_def.meas_type_y = 'Var_meas';

% Optimization
EGO = Robust_EGO( prob, 1, [], @Kriging, robust_def, 200, ...
    'corr', 'corrmatern52', 'iter_max',50 );