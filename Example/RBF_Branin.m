%%% Build a RBF model of the Branin function

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

%%
% Create RBF
rbf = RBF ( prob , 1 , [] );

% Plot output depending on the input_1 and input_2
rbf.Plot( [1,2], [] );

% Plot output depending on the input_1 , with input_2 = 5
rbf.Plot( 1, 5 );

% Compute RMSE with test points
x_test = stk_sampling_maximinlhs( 100, 2, [lb; ub], 200);
x_test = x_test.data;
y_test = Branin( x_test );
rmse = rbf.Rmse( x_test, y_test );




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


