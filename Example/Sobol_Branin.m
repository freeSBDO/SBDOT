%%% Compute Sobol indices of the Branin function

clear all
close all
clc

% Set random seed for reproductibility
rng(1)

% Define problem structure
m_x = 2;      % Number of parameters
m_y = 1;      % Number of objectives
m_g = 1;      % Number of constraint
lb = [-5 0];  % Lower bound 
ub = [10 15]; % Upper bound 

% Create Problem object with optionnal parallel input as true
prob = Problem( 'Branin', m_x, m_y, m_g, lb, ub , 'parallel', true);

% Compute Sobol indices with direct calls to the function
S_obj_prob = Sobol(prob,2,1);


%%
% Evaluate the model on 20 points created with LHS
prob.Get_design( 20 ,'LHS' )

% Create Kriging
krig = Kriging ( prob , 1 , [] );

% Compute Sobol indices on Kriging
S_obj_krig = Sobol(krig,2,1);

% Plot
figure
subplot(1,2,1)
hold on
title('Sobol partial indices','Interpreter','latex')
bar([1 2 3],[S_obj_prob.s_i',S_obj_krig.s_i'])
set(gca,'xtick',[1 2 3])
set(gca,'xticklabel', {'$S_1$','$S_2$','$S_{1-2}$'} ,'TickLabelInterpreter','latex')
legend({'Direct calls','Metamodel'},'Interpreter','latex')
hold off

subplot(1,2,2)
hold on
title('Sobol total indices','Interpreter','latex')
bar([1 2],[S_obj_prob.s_tot',S_obj_krig.s_tot'])
set(gca,'xtick',[1 2])
set(gca,'xticklabel', {'$S_{t_1}$','$S_{t_2}$'} ,'TickLabelInterpreter','latex')
legend({'Direct calls','Metamodel'},'Interpreter','latex')
hold off




% ==========================================================================
%
%    This file is part of SBDOT.
%
%    SBDOT is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    SBDOT is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with SBDOT.  If not, see <http://www.gnu.org/licenses/>.
%
%    Use of SBDOT is free for personal, non-profit, pure academic research
%    and educational purposes. Restrictions apply on commercial or funded
%    research use. Please read the IMPORTANT_LICENCE_NOTICE file.
%
% ==========================================================================


