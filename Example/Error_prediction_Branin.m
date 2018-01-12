%%% Reduce the Kriging prediction error with MSE criterion

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

% Evaluate the model on 20 points created with LHS
prob.Get_design( 20 ,'LHS' )

% Optional parameters for criterion optimization
options_optim.Restarts = 0;

% MSE optimization
obj = Error_prediction(prob, 1, [], @Kriging ,'iter_max',10,'crit_type','MSE','options_optim',options_optim);

% Figure
figure
hold on
plot(prob.x(1:20,1),prob.x(1:20,2),'bo','MarkerFaceColor','b','MarkerSize',8)
plot(prob.x(21:end,1),prob.x(21:end,2),'ro','MarkerFaceColor','r','MarkerSize',8)
xlabel('$x_1$','interpreter','latex')
ylabel('$x_2$','interpreter','latex')
axis([-5 10 0 15])
legend({'Training data $\mathcal{D}$','$\hat y$','Prediction error'},...
    'Interpreter','latex','Location','northwest')
box on
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


