function [] = Opt_crit( obj )
%OPT_CRIT Main method
% Select the new point to evaluate for adaptive sampling sequence

% Build CRN matrix
obj.Compute_CRN();
obj.Find_min_value_opt(); % Find actual minimum value on prediction
obj.Find_min_value_prob(); % Find actual minimum value on "training data"

if obj.m_g >= 1
    
    % constrained optimization
    % Multi-objective optimization (choosen way for constraint handling )
    nsga = NSGA_2( @obj.EI_constrained,...
        obj.lb_rob, obj.ub_rob, nnz(~obj.env_lab) );
    
    % Find the point that maximize EI times Pf in the Pareto front
    prod_fitness = prod( nsga.y ,2 );
    prod_fitness_best = find( prod_fitness == max( prod_fitness ), 1 );
    
    x_new_rob = nsga.x( prod_fitness_best, : );
    obj.EI_val = prod_fitness( prod_fitness_best );
    
else
    
    % unconstrained optimization    
    Initial_point = Unscale_data( rand( 1, nnz(~obj.env_lab) ),...
    obj.lb_rob, obj.ub_rob);

    [x_new_rob, EI] = cmaes( @obj.EI_unconstrained,...
    Initial_point, [], obj.options_optim1);

    obj.EI_val = -EI; 

end

% Select the value of environmental variable to evaluate
if any(obj.env_lab)
    
    Initial_point2 = Unscale_data( rand( 1, nnz(obj.env_lab) ), ...
        obj.options_optim2.LBounds, obj.options_optim2.UBounds);
    
    x_new_env = cmaes( @obj.Optim_env, ...
        Initial_point2, [], obj.options_optim2, x_new_rob);
    
    obj.x_new = [ x_new_rob x_new_env ] ;
    
else
    
    obj.x_new = x_new_rob;
    
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


