clear all
close all
clc

% Set random seed for reproductibility    
rng(1)

% Define problem structure
t = {(1:6)'};
m_t = 6;
m_x = 2;
m_g = 0;
m_y = 1;
lb = 0.01*ones(1,m_x); ub = 0.99*ones(1,m_x);
n_x = 10*ones(1,m_t);
func_str = 'test_multi_obj';

% Create Problem object with optionnal parallel input as true
prob = Q_problem( func_str, t, m_x, m_y, m_g, m_t, lb, ub , 'parallel', true );

% Evaluate the model on 10 points per level created with SLHS method
prob.Get_design( n_x ,'SLHS', 'maximin_type', 'Monte_Carlo', 'n_iter', 1000 );

EGO = Q_multi_obj_EI_MGDA( prob, 1, [], @Q_kriging, Inf, 'optim_method', 'active-set', 'fcall_max', 30, 'iter_max', 30);

Res = zeros(size(EGO.hist.x,1),m_t);

for i = 1:m_t 
    Res(:,i) = test_multi_obj([EGO.hist.x(:,1:2), i.*ones(size(EGO.hist.x,1),1)]);
end

[Worst, I_Worst] = max(Res, [], 2);

[pareto_final, pareto_index] = Q_pareto_points( EGO.meta_y );

x_mat = cell2mat(EGO.prob.x');
x_pareto = x_mat(pareto_index,1:2);

[opt_val, opt_ind] = min(Worst);
opt = EGO.hist.x(opt_ind,1:2);



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


