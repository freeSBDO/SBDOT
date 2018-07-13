clear all
close all
clc

rng(1)

%% Processus Gaussien 

n = 400; % Nombre d'observations
N = 3; % Nombre de chemins à tracer 

mu = 2; % Moyenne
sig2 = 0.5; % Variance
theta1 = 0.1 ; % Hyperparamètre 1
theta2 = 1 ; % Hyperparamètre 2
theta3 = 5 ; % Hyperparamètre 3

lambda = 1e-12; % nugget

% Echantillonage de X 
x = linspace(0,1,n)'; 

% Calcul des distances entre les points
dist_all = abs(bsxfun(@minus,x,permute(x',[3 1 2]))); 
dist_all_theta1(:,:) = sqrt(sum(bsxfun( @times , dist_all , theta1).^2,2));
dist_all_theta2(:,:) = sqrt(sum(bsxfun( @times , dist_all , theta2).^2,2));
dist_all_theta3(:,:) = sqrt(sum(bsxfun( @times , dist_all , theta3).^2,2));

% Générations d'observations normales centrées réduites
ThetaN = normrnd( 0, 1, n, N ); 

% Matrice de correlation exponentielle
cov_exp1=sig2* (exp(-(dist_all_theta1.^2))+diag(lambda.*ones(n,1)));
cov_exp2=sig2* (exp(-(dist_all_theta2.^2))+diag(lambda.*ones(n,1)));
cov_exp3=sig2* (exp(-(dist_all_theta3.^2))+diag(lambda.*ones(n,1)));

Z(:,1) = mu + ( chol(cov_exp1)' ) * ThetaN(:,1); 
Z(:,2) = mu + ( chol(cov_exp2)' ) * ThetaN(:,2); 
Z(:,3) = mu + ( chol(cov_exp3)' ) * ThetaN(:,3); 

figure
hold on
plot( x, Z(:,1), 'b-')
plot( x, Z(:,2), 'g-')
plot( x, Z(:,3), 'r-')
box on
xlabel('$x$','interpreter','latex')
ylabel('$z$','interpreter','latex')
hold off

%% Autocorrélation

x_R = linspace(0,2,n)'; 
R1 = exp(-((x_R.*theta1).^2));
R2 = exp(-((x_R.*theta2).^2));
R3 = exp(-((x_R.*theta3).^2));

figure
hold on
plot( x_R, R1, 'b-')
plot( x_R, R2, 'g-')
plot( x_R, R3, 'r-')
box on
xlabel('$(x -x'')$','interpreter','latex')
ylabel('$R({x}-{x}'')$','interpreter','latex')
legend({'$\theta = 0.1$','$\theta = 1$','$\theta = 5$'},'interpreter','latex')
hold off

