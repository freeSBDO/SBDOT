clear all
close all
clc

rng(1)

theta1 = 0.1 ; % Hyperparametre 1
theta2 = 0.2 ; % Hyperparametre 2
theta3 = 0.3 ; % Hyperparametre 3

% Fonction radiale cubique
x_R = linspace(0,2,400)'; 
R1 = (x_R.*theta1).^3;
R2 = (x_R.*theta2).^3;
R3 = (x_R.*theta3).^3;

figure
hold on
plot( x_R, R1, 'b-')
plot( x_R, R2, 'g-')
plot( x_R, R3, 'r-')
box on
xlabel('$(x -x'')$','interpreter','latex')
ylabel('$\varphi_R({x}-{x}'')$','interpreter','latex')
legend({'$\theta = 0.1$','$\theta = 0.2$','$\theta = 0.3$'},...
    'interpreter','latex','Location','northwest')
title('Cubique','interpreter','latex')
hold off
