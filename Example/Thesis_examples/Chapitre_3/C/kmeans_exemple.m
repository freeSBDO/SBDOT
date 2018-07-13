clear all
close all
clc

% Set random seed for reproductibility
rng(1)

% Problem definition

n_var = 2; % Number of parameters 
lb = [0 0]; % Lower bound
ub = [2 2]; % Upper bound

% NSGA-II optional parameters 

n_pop = 200; % Population number
max_gen = 300; % Number of generation
display = true; % Logical value for display

% NSGA_2

% 'MO_constrained' is the function computing the objectives to optimize and constraints.
% lb and ub are parameters bounds
% n_var is the number of parameters
% See NSGA_2 for other optional parameters.

nsga = NSGA_2('MO_convex_nsga',lb,ub,n_var,'n_pop',n_pop,'max_gen',max_gen,'display',display);

[ cent_K, ind_K ] = Kmeans_SBDO( nsga.x, 3 );

% Plot

figure
hold on
plot( nsga.y(ind_K==1,1), nsga.y(ind_K==1,2), 'bo')
plot( nsga.y(ind_K==2,1), nsga.y(ind_K==2,2), 'ro')
plot( nsga.y(ind_K==3,1), nsga.y(ind_K==3,2), 'go')
xlabel('$\mathcal{M}_1$','interpreter','latex')
ylabel('$\mathcal{M}_2$','interpreter','latex')
box on
hold off

figure
hold on
plot( nsga.x(ind_K==1,1), nsga.x(ind_K==1,2), 'bo')
plot( nsga.x(ind_K==2,1), nsga.x(ind_K==2,2), 'ro')
plot( nsga.x(ind_K==3,1), nsga.x(ind_K==3,2), 'go')
xlabel('$\bf{x}_1$','interpreter','latex')
ylabel('$\bf{x}_2$','interpreter','latex')
box on
hold off
