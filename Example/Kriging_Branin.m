clear all
close all
clc

% Set random seed for reproductibility
rng(1)

% Define problem structure
n_x = 2;
m_y = 1;
m_g = 1;
lb = [-5 0];
ub = [10 15];

% Create Problem object with optionnal parallel input as true
prob = Problem( 'Branin', n_x, m_y, m_g, lb, ub , 'parallel', true);

% Evaluate the model on 20 points created with LHS
prob.Sampling( 20 ,'LHS' )

%%
% Create Kriging
krig = Kriging ( prob , 1 , [] );

% Plot output depending on the input_1 and input_2
krig.Plot( [1,2], [] )

% Plot output depending on the input_1 , with input_2 = 5
krig.Plot( 1, 5 )

%%
% Create Kriging for regression
krig_reg = Kriging ( prob , 1 , [] ,'reg', true );

% Plot output depending on the input_1 and input_2
krig_reg.Plot( [1,2], [] )

%%
% Create Kriging for regression with hyperparameters user defined
krig_reg_set = Kriging ( prob , 1 , [] ,'reg', true , 'hyp_reg', 1e-1 ,'hyp_corr', [10 0.1] );

% Plot output depending on the input_1 and input_2
krig_reg_set.Plot( [1,2], [] )
