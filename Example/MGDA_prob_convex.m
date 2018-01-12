%%% Optimize the multiobjective function MO_convex using MGDA

clear all
close all
clc

rng(1)

% Define problem
lb = [0 0]; % Lower bound
ub = [2 2]; % Upper bound

% Creates starting point of the multi-objective optimization problem
x_temp = stk_sampling_maximinlhs( 100, 2, [lb ; ub], 500 );
x = x_temp.data;

% Optimization
for i=1:100 % Optimize the 100 initial inputs values
    
    % obj = MGDA( function_name, x_start, lb, ub, varargin)
    % 'MO_convex' is the function computing the objectives to optimize.
    % x(i,:) are the starting point of the gradient descent.
    % lb and ub are parameters bounds
    % See MGDA for other optional parameters.
    mgda = MGDA( 'MO_convex', x(i,:), lb, ub, ...
        'display',true,'parallel',false,'grad_available',true,'TOL',1e-2 );
    x_min(i,:) = mgda.x_min;
    f_min(i,:) = mgda.y_min;
    f_call(i,:) = mgda.f_call;
    f_start(i,:) = mgda.hist.y(1,:);
end

% Plot
figure
hold on
plot(f_start(:,1),f_start(:,2),'ro')
plot(f_min(:,1),f_min(:,2),'bo')
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


