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

% Create HF and LF Problem object with optionnal parallel input as true
prob_HF=Problem('Multifi_1D_HF',m_x,m_y,m_g,lb,ub,'parallel',true);
prob_LF=Problem('Multifi_1D_LF',m_x,m_y,m_g,lb,ub,'parallel',true);

% Create Multifidelity Problem object
prob=Problem_multifi(prob_LF,prob_HF);

% Evaluate the models at specified location
prob.Eval ([0;0.1;0.2;0.3;0.4;0.5;0.6;0.7;0.8;0.9;1],'LF');
prob.Eval ([0;0.4;0.6;1],'HF');

% Create Cokriging
corbf1 = CoRBF(prob,1,[]);

% Create Cokriging with specified correlation values
corbf2 = CoRBF(prob,1,[],'hyp_corr_HF',0.1,'hyp_corr_LF',0.1);

% Figure
x_test = linspace(0,1,200)';% x plot points

% Predict values and errors of coRBF
[ pred1, power1] = corbf1.Predict(x_test);
[ pred2, porwer2] = corbf2.Predict(x_test);

% Predict values and errors of low fidelity and difference model
mean_LF = corbf1.RBF_c.Predict(x_test);
mean_diff = corbf1.RBF_d.Predict(x_test);

% Big plot
figure 
hold on 
plot( prob_HF.x, prob_HF.y, 'bo')
plot( x_test, pred1, 'k-')
plot( x_test, mean_diff, 'g-')
plot( prob_LF.x, prob_LF.y, 'bo')
plot( prob_HF.x, corbf1.RBF_d.f_train, 'bo')
plot( x_test, mean_LF, 'g-')
box on
xlabel('$x$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'Training data $\mathcal{D}$','$\hat y$','Low fidelity and difference model'},...
    'Interpreter','latex','Location','northwest')
hold off 

% Plot values and error
figure
hold on
plot( prob_HF.x, prob_HF.y, 'bo')
plot( x_test, pred1, 'k-')
plot( x_test, power1, 'r-')
box on
xlabel('$x$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'Training data $\mathcal{D}$','$\hat y$','Prediction error'},...
    'Interpreter','latex','Location','northwest')
title('CoRBF 1','interpreter','latex')
hold off

% Plot values and error
figure
hold on
plot( prob_HF.x, prob_HF.y, 'bo')
plot( x_test, pred2, 'k-')
plot( x_test, porwer2, 'r-')

box on
xlabel('$x$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'Training data $\mathcal{D}$','$\hat y$','Prediction error'},...
    'Interpreter','latex','Location','northwest')
title('CoRBF 2','interpreter','latex')
hold off
