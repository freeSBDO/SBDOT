clear all
close all
clc

% Set random seed for reproductibility
rng(1)

% Define problem structure
m_x = 1; % Number of parameters
m_y = 1; % Number of objectives
m_g = 0; % Number of constraint
lb = 0;  % Lower bound 
ub = 1;  % Upper bound 

% Create Problem object 
prob_1 = Problem('Multifi_1D_HF',m_x,m_y,m_g,lb,ub,'parallel',true);
prob_1.Eval ([0;0.3;0.5;0.66;0.9;1]);

% Create RBF
rbf_1 = RBF ( prob_1 , 1 , [] );

% Get prediction values
x_test = linspace(0,1,200)';
y_pred_1 = rbf_1.Predict( x_test);

figure
hold on
plot(prob_1.x,prob_1.y,'ro','MarkerFaceColor','r')
plot(x_test,y_pred_1,'b-')
plot([0 1],[-6 -6],'k--')
box on
xlabel('$x$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'Donn\''{e}es d''entrainement $\mathcal{D}$','$\hat y$','Valeur cible'},...
    'Interpreter','latex','Location','northwest')
hold off

% Create Problem object with a new point with a specific value
prob_2 = Problem('Multifi_1D_HF',m_x,m_y,m_g,lb,ub,'parallel',true);
prob_2.Eval([0;0.3;0.5;0.66;0.9;1]);
prob_2.Add_data(0.35,-6,[]);

% Create RBF
rbf_2 = RBF ( prob_2 , 1 , [] );
% Get prediction values
y_pred_2 = rbf_2.Predict( x_test);

figure
hold on
plot(prob_1.x,prob_1.y,'ro','MarkerFaceColor','r')
plot(x_test,y_pred_2,'b-')
plot([0 1],[-6 -6],'k--')
plot(prob_2.x(end),prob_2.y(end),'kd','MarkerFaceColor','k')
box on
xlabel('$x$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'Donn\''{e}es d''entrainement $\mathcal{D}$','$\hat y$','Valeur cible','Lieu potentiel de ${y_{min}}^*$'},...
    'Interpreter','latex','Location','northwest')
hold off

% Create Problem object with a new point with a specific value
prob_3 = Problem('Multifi_1D_HF',m_x,m_y,m_g,lb,ub,'parallel',true);
prob_3.Eval([0;0.3;0.5;0.66;0.9;1]);
prob_3.Add_data(0.75,-6,[]);

% Create RBF
rbf_3 = RBF ( prob_3 , 1 , [] );
% Get prediction values
y_pred_3 = rbf_3.Predict( x_test);

figure
hold on
plot(prob_1.x,prob_1.y,'ro','MarkerFaceColor','r')
plot(x_test,y_pred_3,'b-')
plot([0 1],[-6 -6],'k--')
plot(prob_3.x(end),prob_3.y(end),'kd','MarkerFaceColor','k')
box on
xlabel('$x$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'Donn\''{e}es d''entrainement $\mathcal{D}$','$\hat y$','Valeur cible','Lieu potentiel de ${y_{min}}^*$'},...
    'Interpreter','latex','Location','northwest')
hold off

% Create Problem object with a new point with a specific value
prob_4 = Problem('Multifi_1D_HF',m_x,m_y,m_g,lb,ub,'parallel',true);
prob_4.Eval([0;0.3;0.5;0.66;0.9;1]);
prob_4.Add_data(0.55,-6,[]);

% Create RBF
rbf_4 = RBF ( prob_4 , 1 , [] );
% Get prediction values
y_pred_4 = rbf_4.Predict( x_test);

figure
hold on
plot(prob_1.x,prob_1.y,'ro','MarkerFaceColor','r')
plot(x_test,y_pred_4,'b-')
plot([0 1],[-6 -6],'k--')
plot(prob_4.x(end),prob_4.y(end),'kd','MarkerFaceColor','k')
box on
xlabel('$x$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'Donn\''{e}es d''entrainement $\mathcal{D}$','$\hat y$','Valeur cible','Lieu potentiel de ${y_{min}}^*$'},...
    'Interpreter','latex','Location','northwest')
hold off
