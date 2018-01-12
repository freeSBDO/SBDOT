%%% Build a multifidelity metamodel from two different numerical models
%%% (high fidelity and low fidelity)
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

% Create Cokriging with regression on low fidelity model 
cokrig2 = Cokriging(prob,1,[],'reg_LF',true,'hyp_corr_HF',0.1,'hyp_corr_LF',0.1);

% Figure
x_test = linspace(0,1,200)'; % x plot points

% Predict mean and variance of cokriging
[ mean1, variance1 ] = cokrig1.Predict(x_test);
[ mean2, variance2 ] = cokrig2.Predict(x_test);

% Compute 95% confidence interval
confidence_interval1 = [mean1 - 1.96*sqrt(variance1) ; flipud(mean1 + 1.96*sqrt(variance1))];
confidence_interval2 = [mean2 - 1.96*sqrt(variance2) ; flipud(mean2 + 1.96*sqrt(variance2))];

%% Plot

% Plot cokriging that interpolates dataset and true HF function 
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
hold off

% Plot cokriging for dataset regression
figure
hold on
plot( prob_HF.x, prob_HF.y, 'bo')
plot( x_test, mean2, 'g')
fill( [x_test ; flipud(x_test)], confidence_interval2, 'g','FaceAlpha',0.3,'EdgeColor','none')
box on
xlabel('$x$','interpreter','latex')
ylabel('$\mathcal{M}$','interpreter','latex')
legend({'Training data $\mathcal{D}$','$\hat y$','95\% confidence interval'},...
    'Interpreter','latex','Location','northwest')
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


