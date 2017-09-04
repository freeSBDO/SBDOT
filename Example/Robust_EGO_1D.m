clear all
close all
clc

% Set random seed for reproductibility
rng(1)

% Define problem structure
m_x = 1;
m_y = 1;
m_g = 0;
lb = 0;
ub = 1;

% Create Problem object with optionnal parallel input as true
prob = Problem( 'Robust_1D', m_x, m_y, m_g, lb, ub , 'parallel', true);

% Evaluate the model on 20 points created with LHS
prob.Get_design( 4 ,'LHS' )

% Robust EGO
robust_def.env_lab = [ 0 ];
robust_def.cor_lab = [ 0 ];
robust_def.phot_lab = [ 0 ];
robust_def.unc_type = {'uni'};
robust_def.unc_var=[ 0.2 ];
robust_def.meas_type_y = 'Var_meas';

EGO = Robust_EGO( prob, 1, [], @Kriging, robust_def, 200, ...
    'corr', 'corrmatern52', 'iter_max',50 );