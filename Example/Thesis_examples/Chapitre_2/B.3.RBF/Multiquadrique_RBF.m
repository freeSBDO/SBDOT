clear all
close all
clc

rng(1)

theta1 = 1 ; % Hyperparametre 1
theta2 = 1.5 ; % Hyperparametre 2
theta3 = 2 ; % Hyperparametre 3

% Fonction radiale multiquadrique
x_R = linspace(0,1,400)'; 
R1 = sqrt((1/theta1).^2+x_R.^2);
R2 = sqrt((1/theta2).^2+x_R.^2);
R3 = sqrt((1/theta3).^2+x_R.^2);

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
title('Multiquadrique','interpreter','latex')
hold off
