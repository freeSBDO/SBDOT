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
ub = 1; % Upper bound

% Create HF and LF Problem object with optionnal parallel input as true
prob_HF=Problem('Multifi_1D_HF',m_x,m_y,m_g,lb,ub,'parallel',true);
prob_LF=Problem('Multifi_1D_LF',m_x,m_y,m_g,lb,ub,'parallel',true);

% Create Multifidelity Problem object
prob=Problem_multifi(prob_LF,prob_HF);

% Evaluate the models at specified location
prob.Eval ([0;0.1;0.2;0.3;0.4;0.5;0.6;0.7;0.8;0.9;1],'LF');
prob.Eval ([0;0.4;0.6;1],'HF');

% Create Cokriging
cokrig1 = Cokriging(prob,1,[],'estim_hyp_HF',@pseudoLikelihood,'estim_hyp_LF',@pseudoLikelihood);

% Kriging on HF model
krig2  = Kriging(prob_HF,1,[]);

% Figure
x_test = linspace(0,1,200)';
y_test = Multifi_1D_HF(x_test);

% Prediction
[ mean1, variance1 ] = cokrig1.Predict(x_test);
[ mean2 ] = krig2.Predict(x_test);

% Confidence interval
confidence_interval1 = [mean1 - 1.96*sqrt(variance1) ; flipud(mean1 + 1.96*sqrt(variance1))];

% Kriging prediction
figure
hold on
plot( prob_HF.x, prob_HF.y, 'ko','MarkerFaceColor','k')
plot( x_test, mean2, 'k-')
plot( x_test, y_test, 'k--')
box on
xlabel('$x$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'Donn\''{e}es d''entrainement $\mathcal{D}_{HF}$','$\hat y$ krigeage','$\mathcal{M}$'},...
    'Interpreter','latex','Location','northwest')
hold off

% Multifidelity dataset
figure
hold on
plot( prob_HF.x, prob_HF.y, 'ko','MarkerFaceColor','k')
plot( prob_LF.x, prob_LF.y, 'bo','MarkerFaceColor','b')
box on
xlabel('$x$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'Donn\''{e}es d''entrainement $\mathcal{D}_{HF}$','Donn\''{e}es d''entrainement $\mathcal{D}_{LF}$'},...
    'Interpreter','latex','Location','northwest')
hold off

% Cokriging prediction
figure
hold on
plot( x_test, mean1, 'k-')
fill( [x_test ; flipud(x_test)], confidence_interval1, 'g','FaceAlpha',0.3,'EdgeColor','none')
plot( x_test, y_test, 'k--')
box on
xlabel('$x$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'$\hat y$ co-krigeage','Intervalle de confiance \`{a} 95\%','$\mathcal{M}$'},...
    'Interpreter','latex','Location','northwest')
hold off
