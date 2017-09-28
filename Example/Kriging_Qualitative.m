%% Clear workspace
clear all
close all
clc

% Set random seed for reproductibility
rng(1)

%% 1D
% Define problem structure
% 1 quantitative variable
% 1 qualitative variable (3 levels)
% 1 objective
% 0 constraint

t = {[1;2;3]};              % Qualitative values (cell structure)
m_t = 3;                    % Number of levels per qualitative variable (row vector)
m_x = 1;                    % Number of quantitative variables        
m_g = 0;                    % Number of constraints
m_y = 1;                    % Number of objectives
lb = 0; ub = 1;             % Lower and Upper bounds for the quantitative variable
n_x = 10;                   % Number of points per level-combinations (row vector of length prod(m_t) or scalar -> n_x*ones(1,prod(m_t)))
func_str = 'emse_2';        % Response to surrogate

% Create Problem object with optionnal parallel input as true
prob = Q_problem( func_str, t, m_x, m_y, m_g, m_t, lb, ub , 'parallel', true );

% Evaluate the model on 5 points per level created with OSLHS optimized
% with Monte Carlo method with 1000 random generations
prob.Get_design( n_x ,'SLHS', 'maximin_type', 'Monte_Carlo', 'n_iter', 1000 );

% Construct kriging metamodel on first objective with Gaussian kernel
q_krig = Q_kriging( prob, 1, [], 'corr', 'Q_Gauss');

% Prediction at 0.5 on level 1
pred = q_krig.Predict( 0.5, 1 );

% Prediction and variance on 100 linearly spaced points on level 1
n_eval = 100;
x_eval = linspace(lb,ub,n_eval)';
q = ones(100,1);

[p_mean, p_variance] = q_krig.Predict( x_eval, q );

% Prediction and variance on 100 linearly spaced points on level 1, 2 and 3
n_eval = 100;
x_eval = repmat(linspace(lb,ub,n_eval)',3,1);
q = [ ones(100,1); 2*ones(100,1); 3*ones(100,1) ];

[p_mean, p_variance] = q_krig.Predict( x_eval, q );

% Plot with Q_kriging Method for input 1 output 1 level 1
q_krig.Plot(1,[],1);

% Displaying correlation lengths (stored in log_10)
disp(horzcat('Correlation lengths: ', mat2str(10.^q_krig.hyp_corr)));

% Displaying the inter-levels correlations
T = q_krig.Info_display();

% Displaying the normalized root mean square error

    % Evaluating the response and converting to cells
    y_eval = emse_2( [x_eval,q] );
    x_eval = mat2cell( x_eval, [100,100,100] )';
    y_eval = mat2cell( y_eval, [100,100,100] )';

    % NRMSE
    disp(horzcat('NRMSE: ', num2str(q_krig.Nrmse( x_eval, y_eval ))));

% Error plot (Real values against Predicted values) for the first level
q_krig.Plot_error( x_eval{1}, y_eval{1}, 1);

%% Clear workspace
clear all
close all
clc

% Set random seed for reproductibility
rng(1)

%% 2D
% Define problem structure
% 2 quantitative variable
% 4 qualitative variable (of respectively 2, 3, 2 and 3 levels)
% 1 objective
% 0 constraint

t = {[1;2],[0.5;0.85;1.5],[0.6;1.2],[0.7;0.95;1.4]};    % Qualitative values (cell structure)
m_t = [2, 3, 2, 3];                                     % Number of levels per qualitative variable (row vector)
m_x = 2;                                                % Number of quantitative variables  
m_g = 0;                                                % Number of constraints
m_y = 1;                                                % Number of objectives
lb = -1*ones(1,m_x); ub = ones(1,m_x);                  % Lower and Upper bounds for the quantitative variable
n_x = 20;                                               % Number of points per level-combinations
func_str = 'Q_sin_cos';                                 % Response to surrogate

% Create Problem object with optionnal parallel input as true
prob = Q_problem( func_str, t, m_x, m_y, m_g, m_t, lb, ub , 'parallel', true );

% Evaluate the model on 20 points per level combinations (here 36 combination, i.e. 720 points) created with OSLHS
% optimized with Monte Carlo method with 500 random generations
prob.Get_design( n_x , 'type', 'SLHS', 'maximin_type', 'Monte_Carlo', 'n_iter', 500);

% Construct kriging metamodel on first objective with active-set optimizer
q_krig = Q_kriging( prob, 1, [], 'optim_method', 'active-set');

% Plot with Q_kriging Method for input 1 and 2 output 1 level 1
q_krig.Plot([1 2], [], 1);

% Prediction and variance on 5 points on each level-combination following a sobol sequence

    % Continuous values
    seq = stk_sampling_sobol(5*prod(m_t),2,[lb;ub],true);
    x_eval = seq.data;

    % Qualitative index: corresponding to the indexation of the subscripts
    % of the level-combinations as described in the matlab documentation on
    % ind2sub or sub2ind.
    % (Example in matrices q_sub and q_ind computed below : [1 1 1 1] -> 1, [2 1 1 1] -> 2, ... , [2 3 2 3] -> 36)
    
    q_ind = [];
    for i = 1:prod(m_t)
        q_ind = [q_ind; i*ones(5,1)];
    end

    % Evaluation (with qualitative indexes)
    [p_mean, p_variance] = q_krig.Predict( x_eval, q_ind );

    % Works also with qualitative subscripts
    q_sub = ind2subVect( m_t, q_ind' );
    [p_mean, p_variance] = q_krig.Predict( x_eval, q_sub );

% Evaluation to add points in the problem, adding the points previously predicted

    % Qualitative values
    q_val = q2qval( t, m_t, q_ind );

    % Evaluation
    q_krig.prob.Eval( 5*ones(1,prod(m_t)), [x_eval, q_val] );
    disp(horzcat('Number of points in the design: ', mat2str(q_krig.prob.n_x)));
    
% Displaying correlation lengths (stored in log_10)
disp(horzcat('Correlation lengths: ', mat2str(10.^q_krig.hyp_corr)));

% Displaying the inter-levels correlations
T = q_krig.Info_display();