clear all
close all
clc

save_plot = true;
s = hgexport('readstyle','manuscrit');
s.Format = 'png';

for i = 1 : 20
    
    % Set random seed for reproductibility
    rng(i)
    
    % Define problem structure
    m_x = 2;      % Number of parameters
    m_y = 1;      % Number of objectives
    m_g = 1;      % Number of constraint
    lb = [-5 0];  % Lower bound
    ub = [10 15]; % Upper bound
    
    % Create Problem object with optionnal parallel input as true
    prob = Problem( 'Branin', m_x, m_y, m_g, lb, ub , 'parallel', true);
    
    % Get design
    prob.Get_design( 20 ,'LHS' )
    
    % Instantiate optimization object
    obj = Gutmann_RBF(prob, 1, [], @RBF, 'fcall_max', 18);
    
    % Launch optimization
    obj.Opt();
    
    load Test_points_Branin.mat
    
    RMSE_result(i,:) = obj.meta_y.Rmse(x_test,y_test);
    
    failure(i,:) = obj.failed;    
    x_min_result(i,:) = obj.x_min;
    y_min_result(i,:) = obj.y_min;
    fcall_result(i,:) = obj.fcall_num;
    
    if i == 1
        [ X_plot1, X_plot2 ] = meshgrid( ...
            linspace( -5,10, 200), ...
            linspace( 0, 15, 200) );
        
        X_plot = [ reshape( X_plot1, size( X_plot1, 1)^2, 1)...
            reshape( X_plot2, size( X_plot2, 1 )^2, 1) ];
        
        reshape_size = size(X_plot1);
        
        Y_plot = Branin( X_plot );
        
        figure
        hold on
        plot(prob.x(21:end,1),prob.x(21:end,2),'bo','MarkerFaceColor','b','MarkerSize',8)
        contour(X_plot1,X_plot2,reshape( Y_plot, reshape_size ),20,'k')
        xlabel('$x_1$','interpreter','latex')
        ylabel('$x_2$','interpreter','latex')
        title('$GUT$','interpreter','latex')
        axis([-5 10 0 15])
        box on
        if save_plot
            hgexport(gcf,'Sampling_GUT',s);
        end
        
    end

end

save('Gutmann_result','RMSE_result','failure','x_min_result','y_min_result','fcall_result')
