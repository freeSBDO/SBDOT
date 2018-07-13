clear all 
close all
clc

% Figure options
name_legende = {'EHVI','$EI_{euclid}$','NSGA'};
positions = [1 2 3];
group = [1,2,3];

%% EHVI
load EHVI_results.mat

spread_meas_EHVI = spread_meas;
spacing_meas_EHVI = spacing_meas;
hyp_meas_EHVI = hyp_meas;
nbr_pareto_EHVI = nbr_pareto;

%% EI_euclid
load EI_euclid_results.mat

spread_meas_EI_euclid = spread_meas;
spacing_meas_EI_euclid = spacing_meas;
hyp_meas_EI_euclid = hyp_meas;
nbr_pareto_EI_euclid = nbr_pareto;

%% NSGA

load NSGA_results.mat

spread_meas_NSGA = spread_meas;
spacing_meas_NSGA = spacing_meas;
hyp_meas_NSGA = hyp_meas;
nbr_pareto_NSGA = nbr_pareto;

%% Plots

% Etalement
figure
hold on
boxplot([spread_meas_EHVI,spread_meas_EI_euclid,spread_meas_NSGA],group,'positions',positions,'Colors','rb')
set(gca,'xtick',[1 2 3])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
title('Etalement','interpreter','latex')
box on
hold off

% Espacement
figure
hold on
boxplot([spacing_meas_EHVI,spacing_meas_EI_euclid,spacing_meas_NSGA],group,'positions',positions,'Colors','rb')
set(gca,'xtick',[1 2 3])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
title('Espacement','interpreter','latex')
box on
hold off

% Hypervolume
figure
hold on
boxplot([hyp_meas_EHVI,hyp_meas_EI_euclid,hyp_meas_NSGA],group,'positions',positions,'Colors','rb')
set(gca,'xtick',[1 2 3])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
title('Hypervolume','interpreter','latex')
box on
hold off

% Hypervolume
figure
hold on
boxplot([nbr_pareto_EHVI,nbr_pareto_EI_euclid,nbr_pareto_NSGA],group,'positions',positions,'Colors','rb')
set(gca,'xtick',[1 2 3])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
title('Nombre de points Pareto-optimaux','interpreter','latex')
box on
hold off


