%%% EI optimization using a multifidelity metamodel
%%% Here the surrogate is Cokriging

clear all
close all
clc

% Set random seed for reproductibility
rng(1)

% Define problem structure
m_x = 2; % Number of parameters
m_y = 1; % Number of objectives
m_g = 0; % Number of constraint
lb = [-5 0];  % Lower bound 
ub = [10 15]; % Upper bound 

% Create HF and LF Problem object with optionnal parallel input as true
prob_HF = Problem('Branin',m_x,m_y,m_g,lb,ub,'parallel',true);
prob_LF = Problem('Branin_LF',m_x,m_y,m_g,lb,ub,'parallel',true);

% Create Multifidelity Problem object
prob = Problem_multifi(prob_LF,prob_HF);

% Evaluate the models at specified location
prob.Sampling (20, 4);

% Create Cokriging
cokrig = Cokriging(prob,1,[]);

% EGO optimization
EGO = EI_multifi( prob, 1, [], @Cokriging);
EGO.Opt();

%% Plot

% plot initial co-kriged surface
cokrig.Plot( [1,2], [] );
hold on

% overlay exact Branin surface
[ X_plot1, X_plot2 ] = meshgrid( ...
    linspace( lb(1), ub(1), 200), ...
    linspace( lb(2), ub(2), 200) );
X_plot = [ reshape( X_plot1, size( X_plot1, 1)^2, 1)...
    reshape( X_plot2, size( X_plot2, 1 )^2, 1) ];
reshape_size = size(X_plot1);
Y_plot = Branin( X_plot );
surf( X_plot1, X_plot2, reshape( Y_plot, reshape_size ), ...
    'EdgeColor','none', 'FaceColor', 'r' );

% plot optimized co-kriged surface and additional points
EGO.meta_y.Plot( [1,2], [], 'contourf' );
hold on

plot( EGO.hist.x(:,1), EGO.hist.x(:,2), 'r*' )
plot( EGO.x_min(1), EGO.x_min(2), 'ko', 'MarkerFaceColor', 'r', 'MarkerSize', 8 )
