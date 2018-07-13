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
rbf1 = RBF ( prob1 , 1 , [], 'corr', 'Corrmatern52', 'estimator', 'LOO');
rbf2 = RBF ( prob2 , 1 , [], 'corr', 'Corrmatern52', 'estimator', 'LOO' );

hp = linspace( -5, 3, 200 )';

for i = 1:size(hp,1)
    loo_val_7(i,:) = rbf1.Loo_error( hp(i,:) );
    loo_val_20(i,:) = rbf2.Loo_error( hp(i,:) );
end

%%
% LOO, 7 points
figure
hold on
box on
xlabel('$\log(\theta)$','interpreter','latex')
ylabel('Leave-one-out (\''echelle log)','interpreter','latex') 
line([rbf1.lb_hyp_corr rbf1.lb_hyp_corr],[4.5 7],'Color','r')
line([rbf1.hyp_corr0 rbf1.hyp_corr0],[4.5 7],'Color','g')
line([rbf1.ub_hyp_corr rbf1.ub_hyp_corr],[4.5 7],'Color','r')
plot( hp , log(loo_val_7), 'k-')
legend({'Bornes d''optimisation','Point inital'},...
    'Interpreter','latex','Location','Northeast')
hold off

% LOO, 20 points
figure
hold on
box on
xlabel('$\log(\theta)$','interpreter','latex')
ylabel('Leave-one-out (\''echelle log)','interpreter','latex') 
line([rbf2.lb_hyp_corr rbf2.lb_hyp_corr],[-6 6],'Color','r')
line([rbf2.hyp_corr0 rbf2.hyp_corr0],[-6 6],'Color','g')
line([rbf2.ub_hyp_corr rbf2.ub_hyp_corr],[-6 6],'Color','r')
plot( hp , log(loo_val_20), 'k-')
legend({'Bornes d''optimisation','Point inital'},...
    'Interpreter','latex','Location','southwest')
hold off