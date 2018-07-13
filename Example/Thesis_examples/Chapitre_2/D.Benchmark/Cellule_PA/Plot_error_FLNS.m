clear all
close all
clc

% Load DOE training
load('DOE_FLNS_20_1.mat')

% Create Problem
problem=Problem(@(x)MiniPA_FLNS(x),3,2,0,lb,ub);
problem.Add_data(x,y,[]);

% Build Kriging / RBF
krig_signal=Kriging(problem,1,[],...
    'estim_hyp',@marginalLikelihood,'corr','corrmatern52');
krig_fres=Kriging(problem,2,[],...
    'estim_hyp',@marginalLikelihood,'corr','corrmatern52');

rbf_signal=RBF(problem,1,[],...
    'optimizer','CMAES','corr','Corrmultiquadric');
rbf_fres=RBF(problem,2,[],...
    'optimizer','CMAES','corr','Corrmultiquadric');

% Load DOE test points
load('DOE_FLNS_80.mat')

krig_signal.Plot_error(x,y(:,1))
title('Signal')

krig_fres.Plot_error(x,y(:,2))
title('Fréquence de résonance')

rbf_signal.Plot_error(x,y(:,1))
title('Signal')

rbf_fres.Plot_error(x,y(:,2))
title('Fréquence de résonance')