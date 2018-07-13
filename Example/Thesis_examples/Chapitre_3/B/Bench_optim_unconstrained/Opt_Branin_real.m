clear all
close all
clc

options_optim.TolX = 1e-8; %Tolerance on final optimized input
options_optim.TolFun = 1e-8; %Tolerance on final optimized output
options_optim.DispModulo = 0; % Display message or not during optimization
options_optim.Restarts = 4; % Number of restar of the algorithm
options_optim.LBounds = [-5 0];
options_optim.UBounds = [10 15];
options_optim.IncPopSize = 4;

[ x_min_real , y_min_real ] = cmaes(@Branin, [-3 12], [7 7]',options_optim);

save('Opt_Branin_real','x_min_real','y_min_real')
