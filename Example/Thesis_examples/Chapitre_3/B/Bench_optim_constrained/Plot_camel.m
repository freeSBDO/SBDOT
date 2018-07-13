clear all
close all
clc

% Plot Camel contour lines

[ X_plot1, X_plot2 ] = meshgrid( ...
    linspace( -2, 2, 500), ...
    linspace( -2, 2, 500) );

X_plot = [ reshape( X_plot1, size( X_plot1, 1)^2, 1)...
    reshape( X_plot2, size( X_plot2, 1 )^2, 1) ];

reshape_size = size(X_plot1);

[Y_plot , G_plot] = Camel_constrained( X_plot );

Y_plot(G_plot >0 ,:) = NaN;

figure
hold on
contourf( X_plot1, X_plot2, reshape( Y_plot, reshape_size ), 21 );
contour( X_plot1, X_plot2, reshape( G_plot, reshape_size ), [0,0] ,'r' );
plot(0.02,0.7,'ro','MarkerFaceColor','r')
xlabel('$x_1$','interpreter','latex')
ylabel('$x_2$','interpreter','latex')
colorbar
colormap('jet')
box on
