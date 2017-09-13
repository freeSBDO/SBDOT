% clear all
% close all
% clc
% 
% rng(1)
% 
% % Define problem structure
% t = {[1;2;3]};
% m_t = 3;
% m_x = 1;
% m_g = 0;
% m_y = 1;
% lb = 0; ub = 1;
% n_x = [5,5,5];
% func_str = 'emse_2';
% 
% % Create Problem object with optionnal parallel input as true
% prob = Q_problem( func_str, t, m_x, m_y, m_g, m_t, lb, ub , 'parallel', true );
% 
% % Evaluate the model on 8 points per level created with SLHS method
% prob.Get_design( n_x ,'SLHS', 'maximin_type', 'Monte_Carlo', 'n_iter', 1000 );
% 
% [pareto_init, ~] = Q_pareto_points( Q_kriging( prob, 1, [] ) );
% 
% figure();
% hold on;
% 
% rgb = {'r', 'b', 'g'};
% 
% for i=1:3
%     x_eval = [linspace(0,1,1000)',i*ones(1000,1)];
%     y_eval = emse_2(x_eval);
%     x_samp = prob.x{i}(:,1);
%     y_samp = prob.y{i};
%     plot(x_eval(:,1),y_eval,'Color',rgb{i});
%     plot(x_samp, y_samp,'*','MarkerSize',15,'MarkerEdgeColor',rgb{i},'MarkerFaceColor',rgb{i});
% end
% 
% hline(0, 'k');
% title('EGO iter: 0');
% legend('Y_1',...
%        'D_1',...
%        'Y_2',...
%        'D_2',...
%        'Y_3',...
%        'D_3');
% xlabel('x');
% ylabel('y');
% 
% hold off;
% 
% EGO = Q_multi_obj_EI_MGDA( prob, 1, [], @Q_kriging, Inf, 'fcall_max', 20 );
% 
% [pareto_final, ~] = Q_pareto_points( EGO.meta_y );
% 
% figure();
% hold on;
% 
% scatter3(pareto_init(:,1),pareto_init(:,2),pareto_init(:,3),'MarkerEdgeColor','k','MarkerFaceColor','b');
% scatter3(pareto_final(:,1),pareto_final(:,2),pareto_final(:,3),'MarkerEdgeColor','k','MarkerFaceColor','r');
% 
% hold off
% 
% figure();
% plot(EGO.hist.y_min);
% xlabel('Iterations');
% ylabel('y_m_i_n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
clc

rng(1);

% Define problem structure
t = {[1;2],[0.5;1.5;2.5],[0.6;1.2],[0.7;1.4;2.1]};
m_t = [2, 3, 2, 3];
m_x = 2;
m_g = 0;
m_y = 1;
lb = 0.01*ones(1,m_x);
ub = 0.99*ones(1,m_x);
n_x = 10;
func_str = 'Q_sin_cos';

% Create Problem object with optionnal parallel input as true
prob = Q_problem( func_str, t, m_x, m_y, m_g, m_t, lb, ub , 'parallel', true );

% Evaluate the model on 8 points per level created with SLHS method
prob.Get_design( n_x ,'SLHS', 'maximin_type', 'Monte_Carlo', 'n_iter', 1000 );

EGO = Q_multi_obj_EI_MGDA( prob, 1, [], @Q_kriging, Inf, 'add_seq', false, 'fcall_max', 100 );

figure(); hold on;
plot(EGO.hist.y_min);
plot(EGO.hist.y);
xlabel('Iterations');
ylabel('y_m_i_n');
title('Multi-obj Branin quali 100 iters sans ajout seq');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%