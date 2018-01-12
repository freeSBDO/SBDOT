function [] = Opt_crit( obj )
% OPT_CRIT
% Select the new point to evaluate

obj.Find_min_value(); % Find actual minimum value

if obj.m_g >= 1
    
    % constrained optimization
    % Multi-objective optimization (choosen way for constraint handling )
    nsga = NSGA_2( @obj.EI_constrained,...
        obj.options_optim.lb, obj.options_optim.ub, obj.prob.m_x );
    
    % Find the point that maximize EI times Pf in the Pareto front
    prod_fitness = prod( nsga.y ,2 );
    prod_fitness_best = find( prod_fitness == max( prod_fitness ), 1 );
    
    obj.x_new = nsga.x( prod_fitness_best, : );
    obj.EI_val = prod_fitness( prod_fitness_best );
    
else
    
    % unconstrained optimization    
    Initial_point = Unscale_data( rand( 1, obj.prob.m_x ),...
    obj.options_optim.LBounds, obj.options_optim.UBounds);

    [obj.x_new, EI] = cmaes( @obj.EI_unconstrained,...
    Initial_point, [], obj.options_optim);

    obj.EI_val = -EI; 

end

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


