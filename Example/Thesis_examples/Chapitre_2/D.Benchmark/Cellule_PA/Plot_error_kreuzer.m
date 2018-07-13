clear all
close all
clc

% Load DOE training
load('DOE_Kreuzer_20_1.mat')

% Create Problem
problem=Problem(@(x)MiniPA_kreuzer(x),3,2,0,lb,ub);
problem.Add_data(x,y,[]);

% Build Kriging / RBF
krig_signal=Kriging(problem,1,[],...
    'estim_hyp',@marginalLikelihood,'corr','corrgauss');
krig_fres=Kriging(problem,2,[],...
    'estim_hyp',@marginalLikelihood,'corr','corrgauss');

rbf_signal=RBF(problem,1,[],...
    'optimizer','CMAES','corr','Corrmultiquadric');
rbf_fres=RBF(problem,2,[],...
    'optimizer','CMAES','corr','Corrmultiquadric');

% Load DOE test points
load('DOE_Kreuzer_300.mat')

krig_signal.Plot_error(x,y(:,1))
title('Signal')

krig_fres.Plot_error(x,y(:,2))
title('Fréquence de résonance')

rbf_signal.Plot_error(x,y(:,1))
title('Signal')

rbf_fres.Plot_error(x,y(:,2))
title('Fréquence de résonance')