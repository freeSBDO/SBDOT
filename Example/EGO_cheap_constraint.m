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
prob.Get_design( 20 ,'LHS' )

% Instantiate optimization object
EGO = EI_cheap_constraint( prob, 1, 1, @Kriging, 'Cheap_cons_branin',...
    'corr', 'corrmatern52', 'iter_max',50 );

% Launch optimization
EGO.Opt();

% Plot kriging at end with constraint 
[Y,X]=EGO.meta_y.Plot( [1,2], [] );

% Plot contour values and optimum
g1 = Cheap_cons_branin(X);
[~,g2] = Branin(X);

X1 = reshape( X(:,1), sqrt(size( X, 1)), sqrt(size( X, 1)));
X2 = reshape( X(:,2), sqrt(size( X, 1)), sqrt(size( X, 1)));
Y1 = reshape( Y, sqrt(size( X, 1)), sqrt(size( X, 1)));
G1 = reshape( g1, sqrt(size( X, 1)), sqrt(size( X, 1)));
G2 = reshape( g2, sqrt(size( X, 1)), sqrt(size( X, 1)));

figure
hold on
contour(X1,X2,Y1,30)
contour(X1,X2,G1,[0 0],'r-')
contour(X1,X2,G2,[0 0],'r-')
plot(EGO.x_min(:,1),EGO.x_min(:,2),'ko','MarkerFaceColor','r')
xlabel('$x_1$','interpreter','latex')
ylabel('$x_2$','interpreter','latex')
title('Optimum and constraints','interpreter','latex')
hold off
