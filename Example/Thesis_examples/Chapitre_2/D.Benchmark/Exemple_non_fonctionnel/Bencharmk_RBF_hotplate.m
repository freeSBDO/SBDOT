clear all
close all
clc

rng(1) % Graine de l'aléa

% Différentes fonction de base à tester
corr_tested = {'Corrmatern52', 'Corrmatern32', 'Corrgauss', 'Corrlinear' , 'Corrthinplatespline' , 'Corrmultiquadric', 'Corrinvmultiquadric' , 'Corrcubic'};

col_num = 0;

for i = 1 : 8 % corr
    
    col_num = col_num + 1;
    
    for j = 1 : 10 % DOE
        
        % Il y a 10 plans d'expérience pour moyenner les résultats
        load(['DOE_setBias_100_CVT_',num2str(j),'.mat'])
        
        % Création du problème et ajout des données chargées
        problem=Problem(@(x)FIL3_250_autoBias(x,[650 10]),9,3,2,lb,ub);
        problem.Add_data(x,y,g);
        
        % Construction des RBF sur chaque sortie du modèle
        rbf_radFlux=RBF(problem,1,[],...
            'optimizer','CMAES','corr',corr_tested{i});
        
        rbf_yield=RBF(problem,2,[],...
            'optimizer','CMAES','corr',corr_tested{i});
        
        rbf_Taverage=RBF(problem,3,[],...
            'optimizer','CMAES','corr',corr_tested{i});
        
        rbf_Tmax=RBF(problem,[],1,...
            'optimizer','CMAES','corr',corr_tested{i});
        rbf_Trms=RBF(problem,[],2,...
            'optimizer','CMAES','corr',corr_tested{i});
        
        % Données de validation
        load('DOE_setBias_300_CVT_test.mat')
        
        % Calcul de mesure d'erreur de prédiction sur les données de
        % validation
        RAAE_radFlux(j,col_num)  = rbf_radFlux.Raae(x,y(:,1));
        RMAE_radFlux(j,col_num)  = rbf_radFlux.Rmae(x,y(:,1));
        hyp_corr_radFlux_temp(j,:) = rbf_radFlux.hyp_corr;
        
        RAAE_yield(j,col_num)    = rbf_yield.Raae(x,y(:,2));
        RMAE_yield(j,col_num)    = rbf_yield.Rmae(x,y(:,2));
        hyp_corr_yield_temp(j,:) = rbf_yield.hyp_corr;
        
        RAAE_Taverage(j,col_num)    = rbf_Taverage.Raae(x,y(:,3));
        RMAE_Taverage(j,col_num)    = rbf_Taverage.Rmae(x,y(:,3));
        hyp_corr_Taverage_temp(j,:) = rbf_Taverage.hyp_corr;
        
        RAAE_Tmax(j,col_num)     = rbf_Tmax.Raae(x,g(:,1));
        RMAE_Tmax(j,col_num)     = rbf_Tmax.Rmae(x,g(:,1));
        hyp_corr_Tmax_temp(j,:)  = rbf_Tmax.hyp_corr;
        
        RAAE_Trms(j,col_num)     = rbf_Trms.Raae(x,g(:,2));
        RMAE_Trms(j,col_num)     = rbf_Trms.Rmae(x,g(:,2));
        hyp_corr_Trms_temp(j,:)  = rbf_Trms.hyp_corr;
        
        hyp_corr_radFlux{col_num}  = hyp_corr_radFlux_temp;
        hyp_corr_yield{col_num}    = hyp_corr_yield_temp;
        hyp_corr_Taverage{col_num} = hyp_corr_Taverage_temp;        
        hyp_corr_Tmax{col_num}     = hyp_corr_Tmax_temp;
        hyp_corr_Trms{col_num}     = hyp_corr_Trms_temp;
        
    end
end

% Sauvegarde des résultats
save('Results_setBias_100_CVT_RBF','RAAE_radFlux','RMAE_radFlux','RAAE_yield',...
    'RMAE_yield','RAAE_Taverage','RMAE_Taverage','RAAE_Tmax','RMAE_Tmax','RAAE_Trms','RMAE_Trms',...
    'corr_tested','hyp_corr_radFlux','hyp_corr_yield','hyp_corr_Taverage','hyp_corr_Tmax','hyp_corr_Trms')
