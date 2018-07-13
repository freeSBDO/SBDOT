clear all
close all
clc

rng(1)

% Sobol
x_temp = stk_sampling_sobol( 10^5, 2, [0 0; 10 10], true );
x_sampling = x_temp.data;

% k means
[~,x] = kmeans( x_sampling, 25, 'MaxIter', 500);

% Avec le kmeans de SBDOT :
% x = Kmeans_SBDO( x_sampling, 25);

figure
hold on
plot(x(:,1),x(:,2),'bo','MarkerFaceColor','b')
axis([0 10 0 10])
axis square
box on
xlabel('$x_1$','interpreter','latex')
ylabel('$x_2$','interpreter','latex')
hold off