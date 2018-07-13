clear all
close all
clc

% Load DOE training points
load('DOE_setBias_100_CVT_1.mat')

% Create Problem
problem=Problem(@(x)FIL3_250_setBias(x,[650 10]),9,3,2,lb,ub);
problem.Add_data(x,y,g);

% Build Kriging
krig_radFlux=Kriging(problem,1,[],...
    'estim_hyp',@marginalLikelihood,'corr','correxp');
krig_yield=Kriging(problem,2,[],...
    'estim_hyp',@marginalLikelihood,'corr','correxp');
krig_Taverage=Kriging(problem,3,[],...
    'estim_hyp',@marginalLikelihood,'corr','correxp');
krig_Tmax=Kriging(problem,[],1,...
    'estim_hyp',@marginalLikelihood,'corr','correxp');
krig_Trms=Kriging(problem,[],2,...
    'estim_hyp',@marginalLikelihood,'corr','correxp');

% Build RBF
rbf_radFlux=RBF(problem,1,[],...
    'optimizer','CMAES','corr','Corrcubic');
rbf_yield=RBF(problem,2,[],...
    'optimizer','CMAES','corr','Corrcubic');
rbf_Taverage=RBF(problem,3,[],...
    'optimizer','CMAES','corr','Corrcubic');
rbf_Tmax=RBF(problem,[],1,...
    'optimizer','CMAES','corr','Corrcubic');
rbf_Trms=RBF(problem,[],2,...
    'optimizer','CMAES','corr','Corrcubic');

% Load DOE test points
load('DOE_setBias_300_CVT_test.mat')

krig_radFlux.Plot_error(x,y(:,1))
title('Flux radié')

krig_yield.Plot_error(x,y(:,2))
title('Rendement')

krig_Taverage.Plot_error(x,y(:,3))
title('Température moyenne')

krig_Tmax.Plot_error(x,g(:,1))
title('Température max')

krig_Trms.Plot_error(x,g(:,2))
title('Variation de température')

rbf_radFlux.Plot_error(x,y(:,1))
title('Flux radié')

rbf_yield.Plot_error(x,y(:,2))
title('Rendement')

rbf_Taverage.Plot_error(x,y(:,3))
title('Température moyenne')

rbf_Tmax.Plot_error(x,g(:,1))
title('Température max')

rbf_Trms.Plot_error(x,g(:,2))
title('Variation de température')