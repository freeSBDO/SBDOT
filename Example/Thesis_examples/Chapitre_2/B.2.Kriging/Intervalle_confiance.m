clear all
close all
clc

% Set random seed for reproductibility
rng(1)
% Define problem structure
n_x = 1;
m_y = 1;
m_g = 0;
lb = 0;
ub = 10;

% Create Problem object 
prob = Problem( @(x)x.*sin(x), n_x, m_y, m_g, lb, ub , 'parallel', true);

% Evaluate the model 
prob.Get_design( 6 ,'LHS' )

% Kriging
krig1 = Kriging ( prob , 1 , [] );

% Variance prediction
x_pred = linspace(0,10,200)';

[y_pred1, s_pred1] = krig1.Predict( x_pred );

% Confidence interval
confidence_interval = [y_pred1 - 1.96*sqrt(s_pred1) ; flipud(y_pred1 + 1.96*sqrt(s_pred1))];

% Figure
figure
hold on
plot( prob.x, prob.y, 'bo')
plot( x_pred, y_pred1, 'k-')
fill( [x_pred ; flipud(x_pred)], confidence_interval, 'g','FaceAlpha',0.3,'EdgeColor','none')
box on
xlabel('$x$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'Donn\''{e}es d''entrainement $\mathcal{D}$','$\hat y$','Intervalle de confiance \`{a} 95\%'},...
    'Interpreter','latex','Location','northwest')
axis([0 10 -8 10])
hold off

