clear all 
close all
clc

% Figure options
name_legende = {'EHVI','EI MGDA'};
positions = [1 2];
group = [1,2];

%% EHVI
load EHVI_results.mat

spread_meas_EHVI = spread_meas;
spacing_meas_EHVI = spacing_meas;
hyp_meas_EHVI = hyp_meas;
nbr_pareto_EHVI = nbr_pareto;
min_y_EHVI = min_y;


%% MGDA
load EI_MGDA_results.mat

spread_meas_MGDA = spread_meas;
spacing_meas_MGDA = spacing_meas;
hyp_meas_MGDA = hyp_meas;
nbr_pareto_MGDA = nbr_pareto;
min_y_MGDA  = min_y;


%% Plots

% Etalement
figure
hold on
boxplot([spread_meas_EHVI,spread_meas_MGDA],group,'positions',positions,'Colors','rb')
set(gca,'xtick',[1 2])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
title('Etalement','interpreter','latex')
box on
hold off

% Espacement
figure
hold on
boxplot([spacing_meas_EHVI,spacing_meas_MGDA],group,'positions',positions,'Colors','rb')
set(gca,'xtick',[1 2])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
title('Espacement','interpreter','latex')
box on
hold off

% Hypervolume
figure
hold on
boxplot([hyp_meas_EHVI,hyp_meas_MGDA],group,'positions',positions,'Colors','rb')
set(gca,'xtick',[1 2])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
title('Hypervolume','interpreter','latex')
box on
hold off

% Hypervolume
figure
hold on
boxplot([nbr_pareto_EHVI,nbr_pareto_MGDA],group,'positions',positions,'Colors','rb')
set(gca,'xtick',[1 2])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
title('Nombre de points Pareto-optimaux','interpreter','latex')
box on
hold off

% min_y
figure
hold on
boxplot([min_y_EHVI,min_y_MGDA],group,'positions',positions,'Colors','rb')
set(gca,'xtick',[1 2])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
title('Minimum du pire sc\''enario','interpreter','latex')
box on
hold off
