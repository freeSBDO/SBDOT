clear all
close all
clc

% Set random seed for reproductibility
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
prob.Get_design( 10 ,'LHS' )

% Robust EGO

% Define variables are environmental or not
robust_def.env_lab = [ 0 0 ];
% Define variables are correlated or not
robust_def.cor_lab = [ 0 0 ];
% Define variables are for photonic design or not
robust_def.phot_lab = [ 0 0 ];
% Define variables probability law
robust_def.unc_type = {'det','det'};
% Define variables variance
robust_def.unc_var=[ 0 0 ];
% Define robustness measure on objective
robust_def.meas_type_y = 'Worstcase_meas';

% Optimization
EGO = Robust_EGO_multiobj( prob, [1 2], [], @Kriging, robust_def, 2, ...
    'corr', 'corrmatern52', 'iter_max',50 );





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


