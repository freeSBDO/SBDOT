clear all
close all
clc

% Load result file
load Results_setBias_100_CVT_RBF.mat

% Figure options
name_legende = {'Matern 52', 'Matern 32', 'Gaussienne', 'Lin\''eaire' , 'Spline plaque mince' , 'Multiquadrique' , 'Inverse multiquadrique', 'Cubique'};
positions = [1 1.25 1.5 1.75 2 2.25 2.5 2.75];
group = [1,2,3,4,5,6,7,8];

%% radFlux output

figure

subplot(1,2,1)
hold on
boxplot(RAAE_radFlux,group,'positions',positions,'Colors','rb')
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
ylabel('RAAE','interpreter','latex')
hold off

subplot(1,2,2)
hold on
boxplot(RMAE_radFlux,group,'positions',positions,'Colors','rb')
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
ylabel('RMAE','interpreter','latex')
hold off

figtitle('Flux radi\''e','interpreter','latex')
set(gcf, 'Position', [0 0 1000 600]) 

%% yield output

figure

subplot(1,2,1)
hold on
boxplot(RAAE_yield,group,'positions',positions,'Colors','rb')
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
ylabel('RAAE','interpreter','latex')
hold off

subplot(1,2,2)
hold on
boxplot(RMAE_yield,group,'positions',positions,'Colors','rb')
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
ylabel('RMAE','interpreter','latex')
hold off

figtitle('Rendement','interpreter','latex')
set(gcf, 'Position', [0 0 1000 600]) 

%% Taverage output

figure

subplot(1,2,1)
hold on
boxplot(RAAE_Taverage,group,'positions',positions,'Colors','rb')
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
ylabel('RAAE','interpreter','latex')
hold off

subplot(1,2,2)
hold on
boxplot(RMAE_Taverage,group,'positions',positions,'Colors','rb')
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
ylabel('RMAE','interpreter','latex')
hold off

figtitle('Temp\''erature moyenne','interpreter','latex')
set(gcf, 'Position', [0 0 1000 600]) 

%% Tmax output

figure

subplot(1,2,1)
hold on
boxplot(RAAE_Tmax,group,'positions',positions,'Colors','rb')
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
ylabel('RAAE','interpreter','latex')
hold off

subplot(1,2,2)
hold on
boxplot(RMAE_Tmax,group,'positions',positions,'Colors','rb')
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
ylabel('RMAE','interpreter','latex')
hold off

figtitle('Temp\''erature maximum','Interpreter','latex')
set(gcf, 'Position', [0 0 1000 600]) 

%% Trms output

figure

subplot(1,2,1)
hold on
boxplot(RAAE_Trms,group,'positions',positions,'Colors','rb')
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
ylabel('RAAE','interpreter','latex')
hold off

subplot(1,2,2)
hold on
boxplot(RMAE_Trms,group,'positions',positions,'Colors','rb')
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
ylabel('RMAE','interpreter','latex')
hold off

figtitle('Variation de temp\''erature','interpreter','latex')
set(gcf, 'Position', [0 0 1000 600]) 
