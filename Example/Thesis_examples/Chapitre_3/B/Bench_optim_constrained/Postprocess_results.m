clear all 
close all
clc

% Load optimum point of camel
load Opt_Camel_real.mat

% Figure options
name_legende = {'EI versus PF','EI $\times$ PF','GUT'};
positions = [1 2 3];
group = [1,2,3];

%% EI
load EI_versus_PF_result.mat

distance_x = sqrt(sum((bsxfun(@minus,x_min_real,x_min_result)).^2,2));
EIvPF_distance_x_mean = mean( distance_x );
EIvPF_distance_x_std = std( distance_x );
EIvPF_distance_x = distance_x;

EIvPF_distance_y_mean = mean( abs(y_min_result - y_min_real) );
EIvPF_distance_y_std = std( abs(y_min_result - y_min_real) );
EIvPF_distance_y = abs(y_min_result - y_min_real);

EIvPF_fcall_mean = mean( fcall_result );
EIvPF_fcall_std = std( fcall_result );
EIvPF_fcall = fcall_result;

EIvPF_rmse_mean = mean( RMSE_result_y );
EIvPF_rmse_std = std( RMSE_result_y );
EIvPF_rmse_y = RMSE_result_y;
EIvPF_rmse_g = RMSE_result_g;

%% PI
load EI_times_PF_result.mat

distance_x = sqrt(sum((bsxfun(@minus,x_min_real,x_min_result)).^2,2));
EIxPF_distance_x_mean = mean( distance_x );
EIxPF_distance_x_std = std( distance_x );
EIxPF_distance_x = distance_x;

EIxPF_distance_y_mean = mean( abs(y_min_result - y_min_real) );
EIxPF_distance_y_std = std( abs(y_min_result - y_min_real) );
EIxPF_distance_y = abs(y_min_result - y_min_real);

EIxPF_fcall_mean = mean( fcall_result );
EIxPF_fcall_std = std( fcall_result );
EIxPF_fcall = fcall_result;

EIxPF_rmse_mean = mean( RMSE_result_y );
EIxPF_rmse_std = std( RMSE_result_y );
EIxPF_rmse_y = RMSE_result_y;
EIxPF_rmse_g = RMSE_result_g;

%% Gutmann
load Gutmann_result.mat

distance_x = sqrt(sum((bsxfun(@minus,x_min_real,x_min_result)).^2,2));
Gutmann_distance_x_mean = mean( distance_x );
Gutmann_distance_x_std = std( distance_x );
Gutmann_distance_x = distance_x;

Gutmann_distance_y_mean = mean( abs(y_min_result - y_min_real) );
Gutmann_distance_y_std = std( abs(y_min_result - y_min_real) );
Gutmann_distance_y = abs(y_min_result - y_min_real);

Gutmann_fcall_mean = mean( fcall_result );
Gutmann_fcall_std = std( fcall_result );
Gutmann_fcall = fcall_result;

Gutmann_rmse_mean = mean( RMSE_result );
Gutmann_rmse_std = std( RMSE_result );
Gutmann_rmse_y = RMSE_result_y;
Gutmann_rmse_g = RMSE_result_g;

%% Plots

% distance x
figure
hold on
boxplot([EIvPF_distance_x,EIxPF_distance_x,Gutmann_distance_x],group,'positions',positions,'Colors','rb')
set(gca,'xtick',[1 2 3])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
title('Distance des param\`etres de l''optimum obtenu \`a $x^*$','interpreter','latex')
box on
hold off

% distance y
figure
hold on
boxplot([EIvPF_distance_y,EIxPF_distance_y,Gutmann_distance_y],group,'positions',positions,'Colors','rb')
set(gca,'xtick',[1 2 3])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
title('Distance de la valeur de l''optimum obtenu \`a $\mathcal{M}(x^*)$','interpreter','latex')
box on
hold off

% fcall
figure
hold on
boxplot([EIvPF_fcall,EIxPF_fcall,Gutmann_fcall],group,'positions',positions,'Colors','rb')
set(gca,'xtick',[1 2 3])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
title('Nombre d''appels \`a la fonction \`a optimiser','interpreter','latex')
box on
hold off

% RMSE
figure
hold on
boxplot([EIvPF_rmse_y,EIxPF_rmse_y,Gutmann_rmse_y],group,'positions',positions,'Colors','rb')
set(gca,'xtick',[1 2 3])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
title('RMSE de l''objectif sur 1000 points de r\''eference','interpreter','latex')
hold off

figure
hold on
boxplot([EIvPF_rmse_g,EIxPF_rmse_g,Gutmann_rmse_g],group,'positions',positions,'Colors','rb')
set(gca,'xtick',[1 2 3])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
title('RMSE de la contrainte','interpreter','latex')
hold off
