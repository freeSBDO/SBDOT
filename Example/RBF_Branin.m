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
prob.Get_design( 20 ,'LHS' )

%%
% Create RBF
rbf = RBF ( prob , 1 , [] );

% Plot output depending on the input_1 and input_2
rbf.Plot( [1,2], [] )

% Plot output depending on the input_1 , with input_2 = 5
rbf.Plot( 1, 5 )

x_test = stk_sampling_maximinlhs( 100, 2, [lb; ub], 200);
x_test = x_test.data;
y_test = Branin( x_test );
rmse = rbf.Rmse( x_test, y_test );
