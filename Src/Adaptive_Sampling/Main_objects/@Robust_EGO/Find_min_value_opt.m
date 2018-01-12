function [] = Find_min_value_opt( obj )
% FIND_MIN_VALUE_OPT
% Find the actual minimum value of the optimization problem on predictions

Initial_point = Unscale_data( rand( 1, nnz(~obj.env_lab) ), ...
    obj.options_optim3.LBounds, obj.options_optim3.UBounds);

% Optimization of robustness measure on predictions
[ obj.x_min, obj.y_min ] = cmaes(@obj.Optim_meas, Initial_point, [], obj.options_optim3);

if obj.m_g >= 1
    [~,~,obj.g_min,~] = obj.Eval_rob_meas(obj.x_min);
end

obj.hist.y_min_opt = [ obj.hist.y_min_opt ; obj.y_min ];
obj.hist.x_min_opt = [ obj.hist.x_min_opt ; obj.x_min ];
if obj.m_g >= 1
    obj.hist.g_min_opt = [ obj.hist.g_min_opt ; obj.g_min ];
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


