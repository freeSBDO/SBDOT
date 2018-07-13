clear all
close all
clc

% Nombre de points HF et LF utilisé pour l'entrainement
n_HF = [10 30 50 70 90 110 130];
n_LF = [40 80 120 160 200 240];

% Données de validation
load DOE_borehole_500.mat

for i=1:length(n_HF)
    
    for j=1:length(n_LF)
        
        for k = 1 : 10
            
            rng(k)
            
            m_x = 8; % Nombre de paramètres
            m_y = 1; % Nombre d'objectifs
            m_g = 0; % Nombre de contraintes
            lb = [0.05 100 63070 990 63.1 700 1120 9855];  % Borne inférieure des paramètres
            ub = [0.15 50000 115600 1110 116 820 1680 12045];  % Borne supérieure des paramètres
            
            % Construction des problèmes pour modèle HF et LF
            prob_HF=Problem('borehole_HF',m_x,m_y,m_g,lb,ub,'parallel',true);
            prob_LF=Problem('borehole_LF',m_x,m_y,m_g,lb,ub,'parallel',true);
            
            % Construction du problème multifidélité
            prob = Problem_multifi(prob_LF,prob_HF);
            
            % Création d'un plan d'expérience de type Nested LHS et
            % évaluation des points
            prob.Sampling(n_LF(j),n_HF(i),'Nested');
            
            % Construction de la CoRBF
            corbf_meta = CoRBF(prob,1,[],'corr_HF','Corrgauss','corr_LF','Corrgauss');
            
            % Calcul erreur de prédiction et extraction des hyperparamètres
            RAAE_borehole(i,j,k)  = corbf_meta.Raae(x_test,y_test);
            
        end
    end
end

save('coRBF_borehole_result','RAAE_borehole')
