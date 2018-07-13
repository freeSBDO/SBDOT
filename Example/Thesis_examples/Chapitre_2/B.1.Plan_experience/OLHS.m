clear all
close all
clc

rng(1)

% OLHS
x_temp = stk_sampling_maximinlhs( 25, 2, [0 0; 10 10], 500 );
x = x_temp.data;

figure
hold on
plot(x(:,1),x(:,2),'bo','MarkerFaceColor','b')
axis([0 10 0 10])
axis square
box on
xlabel('$x_1$','interpreter','latex')
ylabel('$x_2$','interpreter','latex')
hold off