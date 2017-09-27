clear all
close all
clc

% Set random seed for reproductibility
rng(1)

% Define problem structure
m_x = 1;
m_y = 1;
m_g = 0;
lb = 0;
ub = 1;

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

% Create Cokriging with regression on low fidelity model 
corbf2 = CoRBF(prob,1,[],'hyp_corr_HF',0.1,'hyp_corr_LF',0.1);


% Figure

x_test = linspace(0,1,200)';

[ mean1, variance1] = corbf1.Predict(x_test);
[ mean2, variance2] = corbf2.Predict(x_test);

mean_LF = corbf1.RBF_c.Predict(x_test);
mean_diff = corbf1.RBF_d.Predict(x_test);
figure 
hold on 
plot( prob_LF.x, prob_LF.y, 'bo')
plot( prob_HF.x, prob_HF.y, 'bo')
plot( prob_HF.x, corbf1.RBF_d.f_train, 'bo')
plot( x_test, mean_LF, 'g-')
plot( x_test, mean_diff, 'g-')
plot( x_test, mean1, 'k-')
hold off 


figure
hold on
plot( prob_HF.x, prob_HF.y, 'bo')
plot( x_test, mean1, 'k-')
plot( x_test, variance1, 'r-')
box on
xlabel('$x$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'Donn\''{e}es d''entrainement $\mathcal{D}$','$\hat y$','Erreur de pr\''{e}diction'},...
    'Interpreter','latex','Location','northwest')
hold off

figure
hold on
plot( prob_HF.x, prob_HF.y, 'bo')
plot( x_test, mean2, 'k-')
plot( x_test, variance2, 'r-')

box on
xlabel('$x$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'Donn\''{e}es d''entrainement $\mathcal{D}$','$\hat y$','Erreur de pr\''{e}diction'},...
    'Interpreter','latex','Location','northwest')
hold off
