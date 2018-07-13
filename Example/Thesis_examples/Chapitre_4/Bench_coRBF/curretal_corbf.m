clear all
close all
clc

% Nombre de points HF et LF utilisé pour l'entrainement
n_HF = [5 10 15 20 25 30 35 40];
n_LF = [20 30 40 50 60 70 80 90 100];

% Données de validation
load DOE_curretal_200.mat

for i=1:length(n_HF)
    
    for j=1:length(n_LF)
        
        for k = 1 : 100
            
            rng(k)
            
            m_x = 2; % Nombre de paramètres
            m_y = 1; % Nombre d'objectifs
            m_g = 0; % Nombre de contraintes
            lb = [0 0]; % Borne inférieure des paramètres
            ub = [1 1]; % Borne supérieure des paramètres
            
            % Construction des problèmes pour modèle HF et LF
            prob_HF=Problem('curretal_HF',m_x,m_y,m_g,lb,ub,'parallel',true);
            prob_LF=Problem('curretal_LF',m_x,m_y,m_g,lb,ub,'parallel',true);
            
            % Construction du problème multifidélité
            prob = Problem_multifi(prob_LF,prob_HF);
            
            % Création d'un plan d'expérience de type Nested LHS et
            % évaluation des points
            prob.Sampling(n_LF(j),n_HF(i),'Nested');
            
            % Construction de la CoRBF
            corbf_meta = CoRBF(prob,1,[],'corr_HF','Corrcubic','corr_LF','Corrcubic');
            
            % Calcul erreur de prédiction et extraction des hyperparamètres
            RAAE_curretal(i,j,k)  = corbf_meta.Raae(x_test,y_test);
            
        end
    end
end

save('coRBF_curretal_result','RAAE_curretal')
