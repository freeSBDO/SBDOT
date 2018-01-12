%%% EI optimization using a multifidelity metamodel
%%% Here the surrogate is Cokriging

clear all
close all
clc

% Set random seed for reproductibility
rng(1)

% Define problem structure
m_x = 1; % Number of parameters
m_y = 1; % Number of objectives
m_g = 0; % Number of constraint
lb = 0;  % Lower bound 
ub = 1;  % Upper bound 

% Create HF and LF Problem object with optionnal parallel input as true
prob_HF = Problem('Multifi_1D_HF',m_x,m_y,m_g,lb,ub,'parallel',true);
prob_LF = Problem('Multifi_1D_LF',m_x,m_y,m_g,lb,ub,'parallel',true);

% Create Multifidelity Problem object
prob = Problem_multifi(prob_LF,prob_HF);

% Evaluate the models at specified location
prob.Eval ([0;0.1;0.2;0.3;0.4;0.5;0.6;0.7;0.8;0.9;1],'LF');
prob.Eval ([0;0.4;0.6;1],'HF');

% Create Cokriging
cokrig1 = Cokriging(prob,1,[]);

% Figure
x_test = linspace(0,1,200)'; % x plot points

% Predict mean and variance of cokriging
[ mean1, variance1 ] = cokrig1.Predict(x_test);

% Compute 95% confidence interval
confidence_interval1 = [mean1 - 1.96*sqrt(variance1) ; flipud(mean1 + 1.96*sqrt(variance1))];

% EGO optimization
EGO = EI_multifi( prob, 1, [], @Cokriging);
EGO.Opt();

% Predict mean of the new cokriging
[ mean2, ~ ] = EGO.meta_y.Predict(x_test);

%% Plot initial and final cokriging prediction

% plot cokriging that interpolates dataset and true HF function 
figure
hold on
plot( prob_HF.x, prob_HF.y, 'bo')
plot( x_test, mean1, 'g')
fill( [x_test ; flipud(x_test)], confidence_interval1, 'g','FaceAlpha',0.3,'EdgeColor','none')

plot( x_test, Multifi_1D_HF(x_test), 'b')

box on
xlabel('$x$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'Training data $\mathcal{D}$','$\hat y$','95\% confidence interval', 'y'},...
    'Interpreter','latex','Location','northwest')

% plot optimization results : new points and updated metamodel
plot( EGO.hist.x, EGO.hist.y, 'ro', 'LineWidth', 2 )
plot( x_test, mean2, 'r-')
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


