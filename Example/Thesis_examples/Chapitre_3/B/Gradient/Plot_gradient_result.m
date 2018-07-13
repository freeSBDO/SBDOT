clear all
close all
clc

% Set random seed for reproductibility
rng(1)

% Optimization
[ f_min1, x_min1 , iter1, f_call1,x_hist1]=steepest_slope_step_opt('square_2D',[-3 2],[-5 -5],[5 5]);

[X1_plot,X2_plot]=meshgrid(-5:0.01:5);
X_plot=[reshape(X1_plot,size(X1_plot,1)^2,1),reshape(X2_plot,size(X1_plot,1)^2,1)];
y_plot=square_2D(X_plot);
y_plot=reshape(y_plot,size(X1_plot,1),size(X1_plot,1));

figure
hold on
plot(x_hist1(:,1),x_hist1(:,2),'ko','MarkerFaceColor','k','MarkerSize',8)
contour(X1_plot,X2_plot,y_plot,[600 500 400 300 200 100 50 20 15 5 1 0.1])
plot(-3,2,'ko','MarkerFaceColor','k','MarkerSize',8')
xlabel('$x_1$','interpreter','latex')
ylabel('$x_2$','interpreter','latex') 
plot([-3;x_hist1(:,1)],[2;x_hist1(:,2)],'k-')
legend({'$\bf{x}^{k}$'},...
    'Interpreter','latex','Location','Northeast')
box on
colorbar
hold off
