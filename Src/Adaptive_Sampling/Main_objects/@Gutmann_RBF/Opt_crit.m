function [] = Opt_crit( obj )
% OPT_CRIT Main method
% Select the new point to evaluate

if isa( obj.prob, 'Problem' )
    
    y = obj.prob.y;      
    n_x = obj.prob.n_x;       
    
else
    y = obj.prob.prob_HF.y;
    n_x = obj.prob.prob_HF.n_x;   
    
end
% See Gutmann algorithm for setting target value
[ ~, alpha ] = sort( y );  

w_n = ( mod( obj.cycle_length - n_x + obj.n0, obj.cycle_length + 1 ) ...
    / obj.cycle_length ) ^2;    

if mod( n_x - obj.n0, obj.cycle_length + 1 ) == 0
    
    obj.k_n( obj.iter_num, : ) = n_x;
    
else
    
    obj.k_n( obj.iter_num, : ) = obj.k_n( obj.iter_num - 1 ) - floor((n_x - obj.n0) / obj.cycle_length);
    
end

Initial_point = Unscale_data( rand( 1, obj.prob.m_x ),...
    obj.options_optim.LBounds, obj.options_optim.UBounds);

[ ~, min_current ] = cmaes(@obj.Prediction, Initial_point, [],obj.options_optim); 

% Set target value
min_target = min_current - w_n *( y(alpha(obj.k_n(end,:))) - min_current ) - 10*eps;

% Optimize criterion
[ obj.x_new , obj.gutmann_val ] = cmaes( @obj.Gutmann_crit, ...
    Initial_point, [], obj.options_optim, min_target);

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


