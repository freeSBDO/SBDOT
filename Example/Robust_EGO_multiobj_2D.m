clear all
close all
clc

% Set random seed for reproductibility
rng(1)

% Define problem structure
m_x = 2;
m_y = 2;
m_g = 0;
lb = [0 0];
ub = [2 2];

% Create Problem object with optionnal parallel input as true
prob = Problem( 'MO_convex', m_x, m_y, m_g, lb, ub , 'parallel', true);

% Evaluate the model on 20 points created with LHS
prob.Get_design( 10 ,'LHS' )

% Robust EGO
robust_def.env_lab = [ 0 0 ];
robust_def.cor_lab = [ 0 0 ];
robust_def.phot_lab = [ 0 0 ];
robust_def.unc_type = {'det','det'};
robust_def.unc_var=[ 0 0 ];
robust_def.meas_type_y = 'Worstcase_meas';

EGO = Robust_EGO_multiobj( prob, [1 2], [], @Kriging, robust_def, 2, ...
    'corr', 'corrmatern52', 'iter_max',50 );

