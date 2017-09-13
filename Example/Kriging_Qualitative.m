clear all
close all
clc

% Set random seed for reproductibility
rng(1)

% 1D
% Define problem structure
t = {[1;2;3]};
m_t = 3;
m_x = 1;
m_g = 0;
m_y = 1;
lb = 0; ub = 1;
n_x = [8,8,8]; n_eval = 1000;
func_str = 'emse_2';

% Create Problem object with optionnal parallel input as true
prob = Q_problem( func_str, t, m_x, m_y, m_g, m_t, lb, ub , 'parallel', true );

% Evaluate the model on 5 points per level created with LHS
prob.Get_design( n_x ,'SLHS', 'maximin_type', 'Monte_Carlo', 'n_iter', 1000 );

% Construct kriging metamodel
q_krig = Q_kriging( prob, 1, [], 'corr', 'Q_Gauss');

% Prediction
temp = ind2subVect(m_t,1:prod(m_t));

x_eval = repmat(linspace(lb,ub,n_eval)',prod(m_t),1);
q = zeros(prod(m_t)*n_eval,length(m_t));

for i = 1:prod(m_t)
    q((1+n_eval*(i-1)):(n_eval*i),:) = repmat(temp(i,:),n_eval,1);
end

[p_mean, p_variance] = q_krig.Predict( x_eval, q );

% Plot with Q_kriging Method for input 1 output 1 level 1
q_krig.Plot(1,[],1);

% More sophisticated plot for input 1 output 1 all levels

fh = str2func(func_str);
x_sample = cell2mat(prob.x');

temp_2 = cumsum(n_x);
temp_2 = [[1,temp_2(1:(end-1))+1];temp_2];

for i=1:prod(m_t)
    ind_eval = (1+n_eval*(i-1)):(n_eval*i);
    ind_samp = temp_2(1,i):temp_2(2,i);
    figure();
    hold on;
    temp = fh([x_eval(ind_eval,1),q(ind_eval,:)]);
    plot(x_eval(ind_eval,1),temp(:,1),'Color','g');
    plot(x_eval(ind_eval,1),p_mean(ind_eval)+1.96.*p_variance(ind_eval),':','Color','b');
    plot(x_eval(ind_eval,1),p_mean(ind_eval)-1.96.*p_variance(ind_eval),':','Color','b');
    plot(x_eval(ind_eval,1),p_mean(ind_eval),'--','Color','r');
    temp = fh(x_sample(ind_samp,:));
    plot(x_sample(ind_samp,1), temp(:,1),'*','MarkerSize',20);
    legend('obj. func.', 'upper conf. int.', 'lower conf. int.', 'mean pred.', 'DoE');
    title('Kriging Example');
    xlabel('x');
    ylabel('y');
    hold off;
end

% fixing hyp_inputs
hyp_dchol = [0.004446,8.3388,3.17262];
hyp_sigma2 = 307.5534471;
hyp_corr = 0.38737;
hyp_tau = [3.128146,0.01114024,3.1414815148];

q_krig = Q_kriging( prob, 1, [], 'tau_type', 'heteroskedastic', 'hyp_dchol', hyp_dchol, 'hyp_sigma2', hyp_sigma2, 'hyp_corr', hyp_corr, 'hyp_tau', hyp_tau);

x_eval = cell2mat(prob.x');
q = x_eval(:,2);
x_eval = x_eval(:,1);

[p_mean, p_variance] = q_krig.Predict( x_eval, q );

q_krig.Plot(1,[],1);

% Fixing hyp_dchol_bounds and hyp_dchol_0 for optimization
lb_hyp_dchol = [0.1, 0.1, 0.1];
ub_hyp_dchol = [0.8, 0.8, 0.8];
hyp_dchol_0 = [0.7, 0.7, 0.7];

q_krig = Q_kriging( prob, 1, [], 'tau_type', 'heteroskedastic', 'hyp_dchol_0', hyp_dchol_0, 'lb_hyp_dchol', lb_hyp_dchol, 'ub_hyp_dchol', ub_hyp_dchol);

x_eval = cell2mat(prob.x');
q = x_eval(:,2);
x_eval = x_eval(:,1);

[p_mean, p_variance] = q_krig.Predict( x_eval, q );

q_krig.Plot(1,[],1);

%% 2D
% Define problem structure
t = {[1;2],[0.5;1.5],[0.6;1.2],[0.7;1.4]};
m_t = [2, 2, 2, 2];
m_x = 2;
m_g = 0;
m_y = 1;
lb = -1*ones(1,m_x);
ub = ones(1,m_x);
n_x = 10;
func_str = 'Q_sin_cos';

% Create Problem object with optionnal parallel input as true
prob = Q_problem( func_str, t, m_x, m_y, m_g, m_t, lb, ub , 'parallel', true );

% Evaluate the model on 7 points per level combinations (here 36 combination, i.e. 252 points) created with SLHS
prob.Get_design( n_x , 'type', 'SLHS', 'maximin_type', 'Monte_Carlo', 'n_iter', 500);

% Construct kriging metamodel
q_krig = Q_kriging( prob, 1, [], 'tau_type', 'isotropic', 'optim_method', 'active-set');

% Test on DoE points
x_eval = cell2mat(prob.x');
x_eval = x_eval(:,1:m_x);

q = zeros(n_x*prod(m_t),1);
for i = 1:prod(m_t)
    q((n_x*(i-1)+1):n_x*i) = i.*ones(n_x,1);
end

[p_mean, p_variance] = q_krig.Predict( x_eval, q );

test_mean = cell2mat(prob.y') - p_mean;

% Plot Method
q_krig.Plot([1 2], [], 1);