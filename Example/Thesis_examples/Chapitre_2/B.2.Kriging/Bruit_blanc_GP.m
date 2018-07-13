clear all
close all
clc

rng(1)

%% Processus Gaussien 

n = 400; % Nombre d'observations
N = 3; % Nombre de chemins à tracer 

mu = 2; % Moyenne
sig2 = 0.5; % Variance

% Echantillonage de X 
x = linspace(0,1,n)'; 

% Générations d'observations normales centrées réduites
ThetaN = normrnd( 0, 1, n, N ); 

% Matrice de correlation bruit blanc 
cov_dirac=sig2*eye(n,n);

for i=1:N
    Z(:,i) = mu + ( chol(cov_dirac)' ) * ThetaN(:,i); 
end

figure
hold on
plot( x, Z, 'b-')
box on
xlabel('$x$','interpreter','latex')
ylabel('$z$','interpreter','latex')
hold off

%% Autocorrélation

R = zeros( n , 1);
R(1) = 1;

figure
hold on
plot( x, R, 'b-')
box on
xlabel('$(x -x'')$','interpreter','latex')
ylabel('$R({x}-{x}'')$','interpreter','latex')
hold off

