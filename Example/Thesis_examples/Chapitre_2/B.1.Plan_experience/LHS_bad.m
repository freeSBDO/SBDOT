clear all
close all
clc

rng(1)

figure
hold on
plot(0.5:9.5,0.5:9.5,'bo','MarkerFaceColor','b')
axis([0 10 0 10])
ax = gca;
ax.XTick = 0:10;
ax.YTick = 0:10;
axis square
box on
grid on
xlabel('$x_1$','interpreter','latex')
ylabel('$x_2$','interpreter','latex')
hold off