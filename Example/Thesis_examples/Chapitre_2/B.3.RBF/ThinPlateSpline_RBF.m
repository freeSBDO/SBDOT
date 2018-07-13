clear all
close all
clc

rng(1)

theta1 = 1 ; % Hyperparametre 1
theta2 = 1.5 ; % Hyperparametre 2
theta3 = 2 ; % Hyperparametre 3

% Fonction radiale spline en plaque mince
x_R = linspace(0,1,400)'; 
R1 = ((x_R.*theta1).^2).*log(x_R.*theta1);
R2 = ((x_R.*theta2).^2).*log(x_R.*theta2);
R3 = ((x_R.*theta3).^2).*log(x_R.*theta3);

figure
hold on
plot( x_R, R1, 'b-')
plot( x_R, R2, 'g-')
plot( x_R, R3, 'r-')
box on
xlabel('$(x -x'')$','interpreter','latex')
ylabel('$\varphi_R({x}-{x}'')$','interpreter','latex')
legend({'$\theta = 1$','$\theta = 1.5$','$\theta = 2$'},...
    'interpreter','latex','Location','northwest')
hold off
title('Spline en plaque mince','interpreter','latex')
