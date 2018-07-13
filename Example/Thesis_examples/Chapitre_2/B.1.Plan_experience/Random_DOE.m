clear all
close all
clc

rng(1)

% Tirage aléatoire uniforme
x_temp = rand(25,2);
x = Unscale_data( x_temp, [0 0] , [10 10] );

figure
hold on
plot(x(:,1),x(:,2),'bo','MarkerFaceColor','b')
axis([0 10 0 10])
axis square
box on
xlabel('$x_1$','interpreter','latex')
ylabel('$x_2$','interpreter','latex')
hold off