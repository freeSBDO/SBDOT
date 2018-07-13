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
ub = 1;  % Upper bound 

% Create Problem object 
prob = Problem('Multifi_1D_HF',m_x,m_y,m_g,lb,ub,'parallel',true);
prob.Eval ([0;0.4;0.6;1]);

% Adaptive sampling 
EGO = Expected_improvement( prob, 1, [], @Kriging,'fcall_max',1);
EGO.Opt_crit; 

% Extract EI values 
x_test = linspace(0,1,200)';
EI_val = EGO.EI_unconstrained(x_test);

% Adaptive sampling 
EGO = Expected_improvement( prob, 1, [], @Kriging, 'criterion', 'PI','fcall_max',1);
EGO.Opt_crit; 

% Extract PI values 
PI_val = EGO.EI_unconstrained(x_test);

% Prediction values and errors
[y_test ,mse_test] = EGO.meta_y.Predict(x_test);
confidence_interval = [y_test - 1.96*sqrt(mse_test) ; flipud(y_test + 1.96*sqrt(mse_test))];

figure
hold on
plot(prob.x,prob.y,'ro','MarkerFaceColor','r')
plot(x_test,y_test,'b-')
plot(x_test,-10*EI_val-5,'k-')
fill( [x_test ; flipud(x_test)], confidence_interval, 'g','FaceAlpha',0.3,'EdgeColor','none')
box on
xlabel('$x$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'Donn\''{e}es d''entrainement $\mathcal{D}$','$\hat y$','$EI$','Intervalle de confiance \`{a} 95\%'},...
    'Interpreter','latex','Location','northwest')
hold off

figure
hold on
plot(prob.x,prob.y,'ro','MarkerFaceColor','r')
plot(x_test,y_test,'b-')
plot(x_test,-10*PI_val-5,'k-')
fill( [x_test ; flipud(x_test)], confidence_interval, 'g','FaceAlpha',0.3,'EdgeColor','none')
box on
xlabel('$x$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'Donn\''{e}es d''entrainement $\mathcal{D}$','$\hat y$','$PI$','Intervalle de confiance \`{a} 95\%'},...
    'Interpreter','latex','Location','northwest')
hold off



