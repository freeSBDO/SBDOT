clear all
close all
clc

% Load result file
load Results_lambda_kriging.mat

% Figure options
name_legende = {'Matern 52 ','Exponentielle','Gaussienne','Matern 32'};
positions = [1 1.25 1.5 1.75 2 2.25 2.5 2.75];
group = [1,2,3,4,5,6,7,8];

%%
figure

subplot(1,2,1)
hold on
boxplot(RAAE,group,'positions',positions,'Colors','rb')
set(gca,'xtick',[1.125 1.625 2.125 2.625])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
ylabel('RAAE','interpreter','latex')
box_vars = findall(gca,'Tag','Box');
legend(box_vars([2,1]), {'MLE','LOO'},'Location','Northwest' ,'Interpreter','latex');
hold off

subplot(1,2,2)
hold on
boxplot(RMAE,group,'positions',positions,'Colors','rb')
set(gca,'xtick',[1.125 1.625 2.125 2.625])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
ylabel('RMAE','interpreter','latex')
hold off

figtitle('Ecart du taux de couplage','interpreter','latex')
set(gcf, 'Position', [0 0 1000 600]) 