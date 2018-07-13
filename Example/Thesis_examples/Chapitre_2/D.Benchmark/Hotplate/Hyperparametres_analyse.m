clear all
close all
clc

% Load result file
load Results_setBias_100_CVT_kriging.mat

% Figure options
name_legende = {'Matern 52 ','Exponentielle','Gaussienne','Matern 32'};
positions = [1 1.25 1.5 1.75];
group = [1,2,3,4];

%Extract hyperparameter values obtained with likelihood optimization
hyp_corr_yield=hyp_corr_yield([1 3 5 7]);

%% radFlux output

for i = 1 : 4
    
    theta1(:,i) = hyp_corr_yield{i}(:,1);
    theta2(:,i) = hyp_corr_yield{i}(:,2);
    theta3(:,i) = hyp_corr_yield{i}(:,3);
    theta4(:,i) = hyp_corr_yield{i}(:,4);
    theta5(:,i) = hyp_corr_yield{i}(:,5);
    theta6(:,i) = hyp_corr_yield{i}(:,6);
    theta7(:,i) = hyp_corr_yield{i}(:,7);
    theta8(:,i) = hyp_corr_yield{i}(:,8);
    theta9(:,i) = hyp_corr_yield{i}(:,9);
    
end

figure

subplot(2,5,1)
hold on
boxplot(theta1,group,'positions',positions)
set(gca,'xtick',[1 1.25 1.5 1.75])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
ylabel('Hyperparam\`etre 1','interpreter','latex')
hold off

subplot(2,5,2)
hold on
boxplot(theta2,group,'positions',positions)
set(gca,'xtick',[1 1.25 1.5 1.75])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
ylabel('Hyperparam\`etre 2','interpreter','latex')
hold off

subplot(2,5,3)
hold on
boxplot(theta3,group,'positions',positions)
set(gca,'xtick',[1 1.25 1.5 1.75])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
ylabel('Hyperparam\`etre 3','interpreter','latex')
hold off

subplot(2,5,4)
hold on
boxplot(theta4,group,'positions',positions)
set(gca,'xtick',[1 1.25 1.5 1.75])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
ylabel('Hyperparam\`etre 4','interpreter','latex')
hold off

subplot(2,5,5)
hold on
boxplot(theta5,group,'positions',positions)
set(gca,'xtick',[1 1.25 1.5 1.75])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
ylabel('Hyperparam\`etre 5','interpreter','latex')
hold off

subplot(2,5,6)
hold on
boxplot(theta6,group,'positions',positions)
set(gca,'xtick',[1 1.25 1.5 1.75])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
ylabel('Hyperparam\`etre 6','interpreter','latex')
hold off

subplot(2,5,7)
hold on
boxplot(theta7,group,'positions',positions)
set(gca,'xtick',[1 1.25 1.5 1.75])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
ylabel('Hyperparam\`etre 7','interpreter','latex')
hold off

subplot(2,5,8)
hold on
boxplot(theta8,group,'positions',positions)
set(gca,'xtick',[1 1.25 1.5 1.75])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
ylabel('Hyperparam\`etre 8','interpreter','latex')
hold off

subplot(2,5,9)
hold on
boxplot(theta9,group,'positions',positions)
set(gca,'xtick',[1 1.25 1.5 1.75])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
ylabel('Hyperparam\`etre 9','interpreter','latex')
hold off

figtitle('Rendement','interpreter','latex')
set(gcf, 'Position', [0 0 1000 600])