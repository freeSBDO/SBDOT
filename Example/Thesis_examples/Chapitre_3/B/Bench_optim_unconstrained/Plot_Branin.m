clear all
close all
clc

save_plot = true;
s = hgexport('readstyle','manuscrit');
s.Format = 'png';

[ X_plot1, X_plot2 ] = meshgrid( ...
    linspace( -5,10, 200), ...
    linspace( 0, 15, 200) );

X_plot = [ reshape( X_plot1, size( X_plot1, 1)^2, 1)...
    reshape( X_plot2, size( X_plot2, 1 )^2, 1) ];

reshape_size = size(X_plot1);

Y_plot = Branin( X_plot );

X = [pi 2.275 ; 9.42478 2.475];

figure
hold on
contourf( X_plot1, X_plot2, reshape( Y_plot, reshape_size ), 21 );
plot(X(:,1), X(:,2), 'wx', 'MarkerSize', 14);
plot(-3.18,12.36,'ro','MarkerFaceColor','r')
xlabel('$x_1$','interpreter','latex')
ylabel('$x_2$','interpreter','latex')
colorbar
colormap('jet')
box on

if save_plot
    hgexport(gcf,'Branin_contour',s);
end
