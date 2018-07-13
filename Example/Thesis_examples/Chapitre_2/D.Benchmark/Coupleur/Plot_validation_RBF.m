clear all
close all
clc

% Load result file
load Results_lambda_RBF.mat

% Figure options
name_legende = {'Matern 52', 'Matern 32', 'Gaussienne', 'Lin\''eaire' , 'Spline plaque mince' , 'Multiquadrique' , 'Inverse multiquadrique', 'Cubique'};
positions = [1 1.25 1.5 1.75 2 2.25 2.5 2.75];
group = [1,2,3,4,5,6,7,8];

%%
figure

subplot(1,2,1)
hold on
boxplot(RAAE,group,'positions',positions,'Colors','r')
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
ylabel('RAAE','interpreter','latex')
hold off

subplot(1,2,2)
hold on
boxplot(RMAE,group,'positions',positions,'Colors','r')
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
ylabel('RMAE','interpreter','latex')
hold off

figtitle('Ecart du taux de couplage','interpreter','latex')
set(gcf, 'Position', [0 0 1000 600]) 