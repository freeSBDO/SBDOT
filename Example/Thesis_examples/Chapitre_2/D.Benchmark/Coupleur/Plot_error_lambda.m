clear all
close all
clc

% Load DOE training
load('DOE_coupler_lambda_1.mat')

% Create Problem
problem=Problem(@(x)Coupleur(x),5,1,0,lb,ub);
problem.Add_data(x,y,[]);

% Build Kriging / RBF
krig=Kriging(problem,1,[],...
    'estim_hyp',@pseudoLikelihood,'corr','correxp','reg',false);

rbf=RBF(problem,1,[],...
    'optimizer','CMAES','corr','Corrlinear');

% Load DOE test points
load('DOE_coupler_lambda_10.mat')

krig.Plot_error(x,y(:,1))
title('Ecart du taux de couplage')

rbf.Plot_error(x,y(:,1))
title('Ecart du taux de couplage')

% Cut view param 1&2
krig.Plot([1 2],[1.25 0.6 1.31])
hold on
xlabel('$W_1$','interpreter','latex')
ylabel('$W_2$','interpreter','latex')
zlabel('$T_c$','interpreter','latex')
hold off

% Cut view param 3&4
krig.Plot([3 4],[0.4 0.4 1.31])
hold on
xlabel('$g_1$','interpreter','latex')
ylabel('$g_2$','interpreter','latex')
zlabel('$T_c$','interpreter','latex')
hold off

% Cut view param 4&5
krig.Plot([4 5],[0.4 0.4 1.25])
hold on
xlabel('$g_2$','interpreter','latex')
ylabel('$\lambda_c$','interpreter','latex')
zlabel('$T_c$','interpreter','latex')
hold off
