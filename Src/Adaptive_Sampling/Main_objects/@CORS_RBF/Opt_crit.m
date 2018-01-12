function [] = Opt_crit( obj )
% OPT_CRIT Main method
% Select the new point to evaluate

% Compute maximin distance
delta_distances = [];

x_temp = stk_sampling_sobol( 1000, obj.prob.m_x, [obj.prob.lb; obj.prob.ub], true );
x_sampling = x_temp.data;

delta_distances(:,:) = sum(abs(bsxfun(@minus,permute(x_sampling,[3 2 1]),obj.prob.x)).^2,2);

obj.delta_mm = max(min(delta_distances,[],1));

if isa( obj.prob, 'Problem' )    
    n_x = obj.prob.n_x;    
else
    n_x = obj.prob.prob_HF.n_x;   
end

% See CORS algorithm for setting Beta_N value
if mod( n_x - obj.n0, obj.cycle_length ) == 0    
    obj.k_n = 1;   
else    
    obj.k_n = obj.k_n + 1;      
end

obj.beta_n = obj.distance_factor(obj.k_n);

Initial_point = Unscale_data( rand( 1, obj.prob.m_x ),...
    obj.options_optim.LBounds, obj.options_optim.UBounds);

[ obj.x_new, obj.cors_val ] = cmaes(@obj.Prediction, Initial_point, [],obj.options_optim); 

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


