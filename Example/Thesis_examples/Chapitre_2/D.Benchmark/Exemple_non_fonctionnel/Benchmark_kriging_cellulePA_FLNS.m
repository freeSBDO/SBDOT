clear all
close all
clc

rng(1) % Graine de l'aléa

% Différentes fonction de corrélation à tester
corr_tested = {'corrmatern52','correxp','corrgauss','corrmatern32'};
% Deux méthodes d'estimation à tester
likelihood_tested = {@marginalLikelihood , @pseudoLikelihood};

col_num = 0;

for i = 1 : 4 % corr    
    
    for k = 1 : 2 % méthode d'estimation
        
        col_num = col_num + 1;
        
        for j = 1:10 % DOE
            
            % Il y a 10 plans d'expérience pour moyenner les résultats
            load(['DOE_FLNS_20_',num2str(j),'.mat'])
            
            % Création du problème et ajout des données chargées
            problem=Problem(@(x)MiniPA_FLNS(x),3,2,0,lb,ub);
            problem.Add_data(x,y,[]);
            
            % Construction du krigeage sur chaque sortie du modèle
            krig_signal=Kriging(problem,1,[],...
                'estim_hyp',likelihood_tested{k},'corr',corr_tested{i});
            krig_fres=Kriging(problem,2,[],...
                'estim_hyp',likelihood_tested{k},'corr',corr_tested{i});
            
            % Données de validation
            load('DOE_FLNS_80.mat')
            
            % Calcul de mesure d'erreur de prédiction sur les données de
            % validation
            RAAE_signal(j,col_num)  = krig_signal.Raae(x,y(:,1));
            RMAE_signal(j,col_num)  = krig_signal.Rmae(x,y(:,1));
            hyp_corr_signal_temp(j,:) = krig_signal.hyp_corr;
            
            RAAE_fres(j,col_num)    = krig_fres.Raae(x,y(:,2));
            RMAE_fres(j,col_num)    = krig_fres.Rmae(x,y(:,2));
            hyp_corr_fres_temp(j,:) = krig_fres.hyp_corr;
            
            hyp_corr_signal{col_num}  = hyp_corr_signal_temp;
            hyp_corr_fres{col_num}    = hyp_corr_fres_temp;
            
        end
    end
end

% Sauvegarde des résultats
save('Results_FLNS_20_kriging','RAAE_signal','RMAE_signal','RAAE_fres',...
    'RMAE_fres','hyp_corr_signal','hyp_corr_fres','corr_tested')
