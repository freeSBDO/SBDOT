clear all
close all
clc

rng(1)

theta1 = 0.1 ; % Hyperparametre 1
theta2 = 1 ; % Hyperparametre 2
theta3 = 5 ; % Hyperparametre 3

% Fonction radiale linéaire
x_R = linspace(0,2,400)'; 
R1 = x_R.*theta1;
R2 = x_R.*theta2;
R3 = x_R.*theta3;

figure
hold on
plot( x_R, R1, 'b-')
plot( x_R, R2, 'g-')
plot( x_R, R3, 'r-')
box on
xlabel('$(x -x'')$','interpreter','latex')
ylabel('$\varphi_R({x}-{x}'')$','interpreter','latex')
legend({'$\theta = 0.1$','$\theta = 1$','$\theta = 5$'},...
    'interpreter','latex','Location','northwest')
title('Lin\''eaire','interpreter','latex')
hold off
