Les fichiers disponibles dans ces dossiers permettent de reproduire les éléments présents dans le manuscrit de thèse de Cédric Durantin.
--- Lien manuscrit à ajouter --- (actuellement indisponible en ligne)
Certains scripts du chapitre 2 ne peuvent être exécuté car les données de simulations nécessaires à leur exécution ne peuvent être fournies.
Ils servent à indiquer comment les résultats ont été générés. 
Il est nécessaire d'ajouter au path de MATLAB le dossier SBDOT avant l'exécution des fichiers.

Chapitre 2 :

	B.1 : Création des plans d'expérience pour reproduire les figures.

	B.2 : - Tracé de processus gaussien
	(Bruit_blanc_GP, Exp_GP, Gauss_GP, Matern32_GP, Matern52_GP)
	      - Propriétés du krigeage 
	(Interpolation_property, Intervalle_confiance, Variance_property)
	      - Méthodes d'estimation des paramètres
	(Maximum_vraisemblance_gauss, Maximum_vraisemblance_matern52) 

	B.3 : - Tracé des fonctions de base
	(Cubique_RBF, Inv_multiquadrique, Lineaire_RBF, Multiquadrique_RBF, ThinPlateSpline_RBF)
	      - Estimation des paramètres
	(LOO_RBF_gauss, LOO_RBF_matern52)
	      - Exemple de RBF
	(RBF_exemple_xsinx)

	C : - Exemple de Cokriging
	(Cokriging_exemple_forrester)

	D Exemple_non_fonctionnel : - Fichier de lancement exemple pour le benchmark de la
	section D sur chaque cas d'application. Ces fichiers ne peuvent être exécuté car les 
	plans d'expérience ne sont pas fournis.

	D : - Plot_error correspond à la figure sur la différence entre les valeurs prédites
	    et les valeurs réelles.
	    - Validation compare les mesures d'erreur de prédiction entre chaque fonction
	    de corrélation ou de base utilisée pour la construction du métamodèle.

Chapitre 3 :

	A : Critère IMSE ou MSE pour le krigeage sur la fonction Branin.

	B : Figure des critères EI, PI et Gutmann
	(Plot_EI_PI, Plot_Gutmann)

	B Gradient : Petit algorithme pour l'exemple sur l'algorithme de gradient
	(script Plot_gradient_result pour le lancement)

	B optim_unconstrained : - Fichiers de lancement pour réaliser l'optimisation de Branin
	                        sans contraintes
	(CORS_bench, EI_bench, Gutmann_bench, PI_bench)
				- Exploitation des résultats 
	(Postprocess_results)
				- Données sur Branin (plot et optimum)
	(Opt_Branin_real, Plot_Branin)

	B optim_constrained : - Fichiers de lancement pour réaliser l'optimisation de Camel
	                        sous contrainte
	(EI_times_PF_opt, EI_versus_PF_opt, Gut_opt)
				- Exploitation des résultats 
	(Postprocess_results)
				- Données sur Camel (plot)
	(Plot_Camel)

Chapitre 4 :

	Bench_coRBF : - Fichier pour la métamodélisation multifidélité par Cokriging ou CoRBF
	(borehole_cokrig, borehole_cokrig_LOO, borehole_corbf, curretal_cokrig, curretal_cokrig_LOO, curretal_corbf)
		      - Figure des résultats
	(plot_borehole, plot_borehole_cokriging_LOO, plot_curretal)

	Bench_EI_MGDA : - Fichier de lancement pour réaliser l'optimisation multi-objectif
	(EHVI_opt, EI_MGDA_opt)
			- Figure des résultats
	(plot_results)
				
	
