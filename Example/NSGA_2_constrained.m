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
