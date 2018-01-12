%%% Optimize the multiobjective function MO_constrained using NSGA

clear all
close all
clc

% Set random seed for reproductibility
rng(1)

% Problem definition

n_var = 2; % Number of parameters 
lb = [0.1 0]; % Lower bound
ub = [1 5]; % Upper bound

% NSGA-II optional parameters 

n_pop = 200; % Population number
max_gen = 300; % Number of generation
display = true; % Logical value for display

% NSGA_2

% 'MO_constrained' is the function computing the objectives to optimize and constraints.
% lb and ub are parameters bounds
% n_var is the number of parameters
% See NSGA_2 for other optional parameters.

nsga = NSGA_2('MO_constrained',lb,ub,n_var,'n_pop',n_pop,'max_gen',max_gen,'display',display);

% Plot

figure
hold on
plot( nsga.hist(1).y(:,1), nsga.hist(1).y(:,2), 'bo')
plot( nsga.y(:,1), nsga.y(:,2), 'ro')
xlabel('Objective 1')
ylabel('Objective 2')
legend('Initial population','Last population')
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


