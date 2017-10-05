%%% Build a mutlifidelity metamodel from two different numerical models
%%% (high fidelity and low fidelity)
%%% Here the surrogate is Cokriging

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
prob_HF = Problem('Multifi_1D_HF',m_x,m_y,m_g,lb,ub,'parallel',true);
prob_LF = Problem('Multifi_1D_LF',m_x,m_y,m_g,lb,ub,'parallel',true);

% Create Multifidelity Problem object
prob = Problem_multifi(prob_LF,prob_HF);

% Evaluate the models at specified location
prob.Eval ([0;0.1;0.2;0.3;0.4;0.5;0.6;0.7;0.8;0.9;1],'LF');
prob.Eval ([0;0.4;0.6;1],'HF');

% Create Cokriging
cokrig1 = Cokriging(prob,1,[]);

% Create Cokriging with regression on low fidelity model 
cokrig2 = Cokriging(prob,1,[],'reg_LF',true,'hyp_corr_HF',0.1,'hyp_corr_LF',0.1);


% Figure
x_test = linspace(0,1,200)'; % x plot points

% Predict mean and variance of cokriging
[ mean1, variance1 ] = cokrig1.Predict(x_test);
[ mean2, variance2 ] = cokrig2.Predict(x_test);

% Compute 95% confidence interval
confidence_interval1 = [mean1 - 1.96*sqrt(variance1) ; flipud(mean1 + 1.96*sqrt(variance1))];
confidence_interval2 = [mean2 - 1.96*sqrt(variance2) ; flipud(mean2 + 1.96*sqrt(variance2))];

% Plot cokriging that interpolates dataset
figure
hold on
plot( prob_HF.x, prob_HF.y, 'bo')
plot( x_test, mean1, 'k-')
fill( [x_test ; flipud(x_test)], confidence_interval1, 'g','FaceAlpha',0.3,'EdgeColor','none')
box on
xlabel('$x$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'Training data $\mathcal{D}$','$\hat y$','95\% confidence interval'},...
    'Interpreter','latex','Location','northwest')
hold off

% Plot cokriging for dataset regression
figure
hold on
plot( prob_HF.x, prob_HF.y, 'bo')
plot( x_test, mean2, 'k-')
fill( [x_test ; flipud(x_test)], confidence_interval2, 'g','FaceAlpha',0.3,'EdgeColor','none')
box on
xlabel('$x$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'Training data $\mathcal{D}$','$\hat y$','95\% confidence interval'},...
    'Interpreter','latex','Location','northwest')
hold off
