function [] = Opt_crit( obj )
% OPT_CRIT
% Select the new point to evaluate

obj.Find_min_value(); % Find actual minimum value

Initial_point = Unscale_data( rand( 1, obj.prob.m_x ),...
    obj.options_optim.LBounds, obj.options_optim.UBounds);

if obj.m_g >= 1
    % constrained
    [obj.x_new, EI] = cmaes( @obj.EI_constrained,...
        Initial_point, [], obj.options_optim);
else
    % unconstrained
    [obj.x_new, EI] = cmaes( @obj.EI_unconstrained,...
        Initial_point, [], obj.options_optim);
end
obj.EI_val = -EI;

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


