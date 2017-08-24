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