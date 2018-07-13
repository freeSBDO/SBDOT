clear all
close all
clc

% Set random seed for reproductibility
rng(1)

% Define problem structure
m_x = 1; % Number of parameters
m_y = 1; % Number of objectives
m_g = 0; % Number of constraints
lb = 0;  % Lower bound
ub = 10; % Upper bound

% Create Problem object 
prob1 = Problem( @(x)x.*sin(x), m_x, m_y, m_g, lb, ub , 'parallel', true);
prob2 = Problem( @(x)x.*sin(x), m_x, m_y, m_g, lb, ub , 'parallel', true);

% Evaluate the model 
prob1.Get_design( 7 ,'LHS' )
prob2.Get_design( 20,'LHS' )


% Kriging
krig1 = Kriging ( prob1 , 1 , [], 'corr', 'corrmatern52', 'estim_hyp', @marginalLikelihood);
krig2 = Kriging ( prob1 , 1 , [], 'corr', 'corrmatern52', 'estim_hyp', @pseudoLikelihood );

krig3 = Kriging ( prob2 , 1 , [], 'corr', 'corrmatern52', 'estim_hyp', @marginalLikelihood);
krig4 = Kriging ( prob2 , 1 , [], 'corr', 'corrmatern52', 'estim_hyp', @pseudoLikelihood );

hp = linspace( -5, 3, 200 )';

for i = 1:size(hp,1)
    likelihood_val_7(i,:) = krig1.k_oodace.likelihood( krig1.k_oodace.getRegressionMatrix, hp(i,:) );
    loo_val_7(i,:) = krig2.k_oodace.likelihood( krig2.k_oodace.getRegressionMatrix, hp(i,:) );
    likelihood_val_20(i,:) = krig3.k_oodace.likelihood( krig3.k_oodace.getRegressionMatrix, hp(i,:) );
    loo_val_20(i,:) = krig4.k_oodace.likelihood( krig4.k_oodace.getRegressionMatrix, hp(i,:) );
end

% Prediction
x_pred = linspace(0,10,200)';

y_pred1 = krig1.Predict( x_pred );
y_pred2 = krig2.Predict( x_pred );
y_real = x_pred .* sin(x_pred);

% Kriging prediction
figure
hold on
plot( prob1.x, prob1.y, 'bo')
plot( x_pred, y_real, 'b--')
plot( x_pred, y_pred1, 'k-')
plot( x_pred, y_pred2, 'r-')
box on
xlabel('$x$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'Donn\''{e}es d''entrainement $\mathcal{D}$','$\mathcal{M}(x) = x \times sin(x)$','Vraisemblance','Leave-one-out'},...
    'Interpreter','latex','Location','northwest')
axis([0 10 -8 10])
hold off

% Vraisemblance, 7 points
figure
hold on
box on
xlabel('$\log(\theta)$','interpreter','latex')
ylabel('Fonction de vraisemblance r\''{e}duite','interpreter','latex') 
line([krig1.lb_hyp_corr krig1.lb_hyp_corr],[-5 30],'Color','r')
line([log10(krig1.hyp_corr0) log10(krig1.hyp_corr0)],[-5 30],'Color','g')
line([krig1.ub_hyp_corr krig1.ub_hyp_corr],[-5 30],'Color','r')
plot( hp , likelihood_val_7, 'k-')
legend({'Bornes d''optimisation','Point inital'},...
    'Interpreter','latex','Location','northwest')
hold off

% LOO, 7 points
figure
hold on
box on
xlabel('$\log(\theta)$','interpreter','latex')
ylabel('Leave-one-out','interpreter','latex')
line([krig1.lb_hyp_corr krig1.lb_hyp_corr],[7 10],'Color','r')
line([log10(krig1.hyp_corr0) log10(krig1.hyp_corr0)],[7 10],'Color','g')
line([krig1.ub_hyp_corr krig1.ub_hyp_corr],[7 10],'Color','r')
plot( hp , loo_val_7, 'k-')
legend({'Bornes d''optimisation','Point inital'},...
    'Interpreter','latex','Location','northwest')
hold off

% Vraisemblance, 20 points
figure
hold on
box on
xlabel('$\log(\theta)$','interpreter','latex')
ylabel('Fonction de vraisemblance r\''{e}duite','interpreter','latex') 
line([krig3.lb_hyp_corr krig3.lb_hyp_corr],[-45 0],'Color','r')
line([log10(krig3.hyp_corr0) log10(krig3.hyp_corr0)],[-45 0],'Color','g')
line([krig3.ub_hyp_corr krig3.ub_hyp_corr],[-45 0],'Color','r')
plot( hp , likelihood_val_20, 'k-')
legend({'Bornes d''optimisation','Point inital'},...
    'Interpreter','latex','Location','northwest')
hold off

% LOO, 7 points
figure
hold on
box on
xlabel('$\log(\theta)$','interpreter','latex')
ylabel('Leave-one-out','interpreter','latex')
line([krig3.lb_hyp_corr krig3.lb_hyp_corr],[-60 30],'Color','r')
line([log10(krig3.hyp_corr0) log10(krig3.hyp_corr0)],[-60 30],'Color','g')
line([krig3.ub_hyp_corr krig3.ub_hyp_corr],[-60 30],'Color','r')
plot( hp , loo_val_20, 'k-')
legend({'Bornes d''optimisation','Point inital'},...
    'Interpreter','latex','Location','northwest')
hold off