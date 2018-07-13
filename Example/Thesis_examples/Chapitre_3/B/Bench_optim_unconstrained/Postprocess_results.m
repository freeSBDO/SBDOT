clear all 
close all
clc

% Load optimum point of Branin
load Opt_Branin_real.mat

% Figure options
name_legende = {'EI','CORS','GUT'};
positions = [1 2 3];
group = [1,2,3];

%% EI
load EI_result.mat

distance_x = sqrt(sum((bsxfun(@minus,x_min_real,x_min_result)).^2,2));
EI_distance_x_mean = mean( distance_x );
EI_distance_x_std = std( distance_x );
EI_distance_x = distance_x;

EI_distance_y_mean = mean( abs(y_min_result - y_min_real) );
EI_distance_y_std = std( abs(y_min_result - y_min_real) );
EI_distance_y = abs(y_min_result - y_min_real);

EI_fcall_mean = mean( fcall_result );
EI_fcall_std = std( fcall_result );
EI_fcall = fcall_result;

EI_rmse_mean = mean( RMSE_result );
EI_rmse_std = std( RMSE_result );
EI_rmse = RMSE_result;

%% PI
load PI_result.mat

distance_x = sqrt(sum((bsxfun(@minus,x_min_real,x_min_result)).^2,2));
PI_distance_x_mean = mean( distance_x );
PI_distance_x_std = std( distance_x );
PI_distance_x = distance_x;

PI_distance_y_mean = mean( abs(y_min_result - y_min_real) );
PI_distance_y_std = std( abs(y_min_result - y_min_real) );
PI_distance_y = abs(y_min_result - y_min_real);

PI_fcall_mean = mean( fcall_result );
PI_fcall_std = std( fcall_result );
PI_fcall = fcall_result;

PI_rmse_mean = mean( RMSE_result );
PI_rmse_std = std( RMSE_result );
PI_rmse = RMSE_result;

%% CORS
load CORS_result.mat

distance_x = sqrt(sum((bsxfun(@minus,x_min_real,x_min_result)).^2,2));
CORS_distance_x_mean = mean( distance_x );
CORS_distance_x_std = std( distance_x );
CORS_distance_x = distance_x;

CORS_distance_y_mean = mean( abs(y_min_result - y_min_real) );
CORS_distance_y_std = std( abs(y_min_result - y_min_real) );
CORS_distance_y = abs(y_min_result - y_min_real);

CORS_fcall_mean = mean( fcall_result );
CORS_fcall_std = std( fcall_result );
CORS_fcall = fcall_result;

CORS_rmse_mean = mean( RMSE_result );
CORS_rmse_std = std( RMSE_result );
CORS_rmse = RMSE_result;

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
Gutmann_rmse = RMSE_result;
%% Plots

% distance x
figure
hold on
boxplot([EI_distance_x,CORS_distance_x,Gutmann_distance_x],group,'positions',positions,'Colors','rb')
set(gca,'xtick',[1 2 3])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
title('Distance des param\`etres de l''optimum obtenu \`a $x^*$','interpreter','latex')
box on
hold off

% distance y
figure
hold on
boxplot([EI_distance_y,CORS_distance_y,Gutmann_distance_y],group,'positions',positions,'Colors','rb')
set(gca,'xtick',[1 2 3])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
title('Distance de la valeur de l''optimum obtenu \`a $\mathcal{M}(x^*)$','interpreter','latex')
box on
hold off

% fcall
figure
hold on
boxplot([EI_fcall,CORS_fcall,Gutmann_fcall],group,'positions',positions,'Colors','rb')
set(gca,'xtick',[1 2 3])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
title('Nombre d''appels \`a la fonction \`a optimiser','interpreter','latex')
box on
hold off

% RMSE
figure
hold on
boxplot([EI_rmse,CORS_rmse,Gutmann_rmse],group,'positions',positions,'Colors','rb')
set(gca,'xtick',[1 2 3])
set(gca,'xticklabel', name_legende ,'TickLabelInterpreter','latex')
set(gca,'XTickLabelRotation', 45)
title('RMSE sur 1000 points de r\''eference','interpreter','latex')
hold off
