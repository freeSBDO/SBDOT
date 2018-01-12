function [] = Opt_crit( obj )
%OPT_CRIT Main method
% Select the new point to evaluate

% Extract pareto points and reference points
obj.y_pareto_temp = Pareto_points(obj.prob.y(:,obj.y_ind));
obj.y_ref_temp = max( obj.y_pareto_temp, [], 1 ) + 1e-6 ;

% Obtain pareto front from kriging prediction
nsga_result = NSGA_2( @(x)deal(obj.Obj_func_nsga(x),[]), ...
    obj.prob.lb, obj.prob.ub, obj.prob.m_x, obj.options_optim );

x_pareto = nsga_result.x;

% Select N_eval points in pareto front using Kmeans

if obj.N_eval == Inf
    k_opt = Kmeans_analysis_SBDO( x_pareto, 'display', false );
else
    k_opt = obj.N_eval;
end

x_start = Kmeans_SBDO( x_pareto, k_opt );

% EI multiobjective optimization using MGDA from x_start

for i = 1 : size(x_start,1)
    
    mgda_result = MGDA( @obj.Obj_func_EI , x_start(i,:), ...
        obj.prob.lb, obj.prob.ub, 'display', false, 'parallel', true, ...
        'grad_available', false, 'TOL',1e-2 );
    x_eval(i,:) = mgda_result.x_min;
    y_EI(i,:) = prod( mgda_result.y_min );
    
end

% Sort optimum based on the prod(EI)
[ ~, I_filter ] = sort( y_EI );
x_eval = x_eval( I_filter, : );

% Filtering
x_eval_filtered=obj.K_filtering(x_eval);

% x_eval checks
x_eval_test = ismembertol( x_eval_filtered,...
    obj.prob.x, obj.prob.tol_eval, 'Byrows',true );
x_eval_filtered( x_eval_test, : ) = [];

obj.x_new = x_eval_filtered;
obj.conv_crit = size( x_eval_filtered, 1);

end





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


