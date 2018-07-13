clear all
close all
clc

for i = 1 : 20
    
    % Set random seed for reproductibility
    rng(i)
    
    % Define problem structure
    m_x = 2;      % Number of parameters
    m_y = 1;      % Number of objectives
    m_g = 1;      % Number of constraint
    lb = [-2 -2];  % Lower bound
    ub = [2 2]; % Upper bound
    
    % Create Problem object with optionnal parallel input as true
    prob = Problem( 'Camel_constrained', m_x, m_y, m_g, lb, ub , 'parallel', true);
    
    % Get design
    prob.Get_design( 20 ,'LHS' )
    
    % Instantiate optimization object
    obj = EI_times_PF(prob, 1, 1, @Kriging, 'fcall_max', 50);
    
    % Launch optimization
    obj.Opt();
    
    load Test_points_Camel.mat
    
    RMSE_result_y(i,:) = obj.meta_y.Rmse(x_test,y_test);
    RMSE_result_g(i,:) = obj.meta_g.Rmse(x_test,y_test);
    
    failure(i,:) = obj.failed;    
    x_min_result(i,:) = obj.x_min;
    y_min_result(i,:) = obj.y_min;
    fcall_result(i,:) = obj.fcall_num;
    
        if i == 1
        
        figure
        hold on
        plot(prob.x(21:end,1),prob.x(21:end,2),'bo','MarkerFaceColor','b','MarkerSize',8)
        xlabel('$x_1$','interpreter','latex')
        ylabel('$x_2$','interpreter','latex')
        title('EI $\times$ PF','interpreter','latex')
        axis([-2 2 -2 2])
        box on
        
        end

end

save('EI_times_PF_result','RMSE_result_y','RMSE_result_g','failure','x_min_result','y_min_result','fcall_result')
