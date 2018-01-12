function [] = Set_options_optim( obj, user_opt )
%SET_OPTIONS_OPTIM Set options for optimization
%   User defined or basic options

if isempty(user_opt)
    
    obj.options_optim.TolX = 1e-4; %Tolerance on final optimized input
    obj.options_optim.TolFun = 1e-4; %Tolerance on final optimized output
    obj.options_optim.DispModulo = 0; % Display message or not during optimization
    obj.options_optim.Restarts = 2; % Number of restar of the algorithm
    obj.options_optim.PopSize = 20;
    
else
    
    obj.options_optim = user_opt;
    if ~isfield(obj.options_optim,'TolX')
        obj.options_optim.TolX = 1e-4; end
    if ~isfield(obj.options_optim,'TolFun')
        obj.options_optim.TolFun = 1e-4; end
    if ~isfield(obj.options_optim,'DispModulo')
        obj.options_optim.DispModulo = 0; end
    if ~isfield(obj.options_optim,'Restarts')
        obj.options_optim.Restarts = 2; end
    if ~isfield(obj.options_optim,'EvalParallel')
        obj.options_optim.EvalParallel = 'no'; end
    
end

obj.options_optim.LBounds = obj.prob.lb;
obj.options_optim.UBounds = obj.prob.ub;

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


