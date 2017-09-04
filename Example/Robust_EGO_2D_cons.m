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

% Evaluate the model on 20 points created with LHS
prob.Get_design( 15 ,'LHS' )

% Robust EGO
robust_def.env_lab = [ 0 0 ];
robust_def.cor_lab = [ 0 0 ];
robust_def.phot_lab = [ 0 0 ];
robust_def.unc_type = {'uni','uni'};
robust_def.unc_var=[ 2 0 ];
robust_def.meas_type_y = 'Mean_meas';
robust_def.meas_type_g = 'Worstcase_meas';

EGO = Robust_EGO( prob, 1, 1, @Kriging, robust_def, 500, ...
    'corr', 'corrmatern52', 'iter_max',50 );