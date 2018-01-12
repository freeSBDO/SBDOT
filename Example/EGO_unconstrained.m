%%% Optimize the output of a numerical model with no constraints 
%%% The criterion used here is the Expected Improvement

% 2017/10/20 : changes in plots (agl)

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

% Instantiate optimization object
EGO = Expected_improvement( prob, 1, [], @Kriging, ...
    'corr', 'corrmatern52', 'iter_max',50 );

% Launch optimization 
EGO.Opt();

%% plots

% 3D plot of the final metamodel and optimum
EGO.meta_y.Plot( [1,2], [] );
hold on
plot3(EGO.x_min(:,1),EGO.x_min(:,2),EGO.y_min,'ro','MarkerFaceColor','r')

% Contour plot of the Branin function
EGO.meta_y.Plot( [1,2], [], 'contourf' );

% plot true local minima of the Branin function
X = [-pi 12.275 ; pi 2.275 ; 9.42478 2.475];
Y = Branin(X);
hold on
plot(X(:,1), X(:,2), 'wx', 'MarkerSize', 14);

% plot minimum found by EGO
plot(EGO.x_min(:,1),EGO.x_min(:,2),'ro','MarkerFaceColor','r')





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


