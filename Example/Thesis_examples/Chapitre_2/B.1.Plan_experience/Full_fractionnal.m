clear all
close all
clc

rng(1)

% Grille de points
[x1 , x2] = meshgrid(linspace(1.25,8.75,5));

x1 = reshape(x1,25,1);
x2 = reshape(x2,25,1);

figure
hold on
plot(x1,x2,'bo','MarkerFaceColor','b')
axis([0 10 0 10])
axis square
box on
xlabel('$x_1$','interpreter','latex')
ylabel('$x_2$','interpreter','latex')
hold off