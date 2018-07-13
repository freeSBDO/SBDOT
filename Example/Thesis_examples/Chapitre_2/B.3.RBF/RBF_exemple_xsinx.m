clear all
close all
clc

% Set random seed for reproductibility
rng(1)

% Define problem structure
m_x = 1; % Number of parameters
m_y = 1; % Number of objectives
m_g = 0; % Number of constraints
lb = 0;  % Lower bound
ub = 10; % Upper bound

% Create Problem object 
prob1 = Problem( @(x)x.*sin(x), m_x, m_y, m_g, lb, ub , 'parallel', true);

% Evaluate the model 
prob1.Get_design( 7 ,'LHS' )

% Kriging
rbf1 = RBF ( prob1 , 1 , [], 'corr', 'Corrcubic');
rbf2 = RBF ( prob1 , 1 , [], 'corr', 'Corrmatern52');
rbf3 = RBF ( prob1 , 1 , [], 'corr', 'Corrinvmultiquadric');


x_pred = linspace(0,10,200)';
y_test = x_pred .* sin(x_pred);

[y_pred1, s_pred1] = rbf1.Predict( x_pred );
[y_pred2, s_pred2] = rbf2.Predict( x_pred );
[y_pred3, s_pred3] = rbf3.Predict( x_pred );


%%
% RBF prediction
figure
hold on
plot( prob1.x, prob1.y, 'ko')
plot( x_pred, y_test, 'k-')
plot( x_pred, y_pred1, 'b--')
plot( x_pred, y_pred2, 'g--')
plot( x_pred, y_pred3, 'r--')
box on
xlabel('$x$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'Donn\''{e}es d''entrainement $\mathcal{D}$','$\mathcal{M}$','RBF cubique','RBF mat\''ern 5/2','RBF inverse multiquadrique'},...
    'Interpreter','latex','Location','northwest')
axis([0 10 -6 8])
hold off
