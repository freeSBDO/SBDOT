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
    lb = [-5 0];  % Lower bound
    ub = [10 15]; % Upper bound
    
    % Create Problem object with optionnal parallel input as true
    prob = Problem( 'Branin', m_x, m_y, m_g, lb, ub , 'parallel', true);
    
    % Get design
    prob.Get_design( 20 ,'LHS' )
    
    % Instantiate optimization object
    obj = Expected_improvement(prob, 1, [], @Kriging, 'fcall_max', 40 ,'criterion', 'PI');
    
    % Launch optimization
    obj.Opt();
    
    load Test_points_Branin.mat
    
    RMSE_result(i,:) = obj.meta_y.Rmse(x_test,y_test);
    
    failure(i,:) = obj.failed;    
    x_min_result(i,:) = obj.x_min;
    y_min_result(i,:) = obj.y_min;
    fcall_result(i,:) = obj.fcall_num;

end

save('PI_result','RMSE_result','failure','x_min_result','y_min_result','fcall_result')
