%%% Optimize the multiple output of a numerical model at the same time.
%%% The criterion used here is the MOEGO strategy with MGDA on EI.

clear all
close all
clc

rng(1)

% Define problem structure
m_x = 2;    % Number of parameters
m_y = 2;    % Number of objectives
m_g = 0;    % Number of constraint
lb = [0 0]; % Lower bound 
ub = [2 2]; % Upper bound  

% Create Problem object with optionnal parallel input as true
prob = Problem( 'MO_convex', m_x, m_y, m_g, lb, ub , 'parallel', true);

% Evaluate the model on 20 points created with LHS
prob.Get_design( 20 ,'LHS' )

% Pareto front before optimization
pareto_init = Pareto_points( prob.y(:,[1 2]) );

% Instantiate optimization object
EGO = Multi_obj_EI_MGDA( prob, [1 2], [], @Kriging, Inf, ...
    'corr', 'corrmatern52', 'fcall_max',40 );

% Pareto front after optimization
pareto_final = Pareto_points( prob.y(:,[1 2]) );

% Plot
figure
hold on
plot(pareto_init(:,1),pareto_init(:,2),'ro')
plot(pareto_final(:,1),pareto_final(:,2),'bo')
legend('Initial data','Optimization result')
xlabel('Objective 1')
ylabel('Objective 2')
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


