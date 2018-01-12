function [] = Set_options_optim( obj, user_opt )
%SET_OPTIONS_OPTIM Set options for optimization
%   User defined or basic options

if isempty(user_opt)
    
    obj.options_optim.n_pop = 200;
    obj.options_optim.max_gen = 200;
    obj.options_optim.fraction_croisement = 2/obj.prob.m_x;
    obj.options_optim.ratio_croisement = 1.2;
    obj.options_optim.fraction_mutation = 2/obj.prob.m_x;
    obj.options_optim.scale_mutation = 0.1;
    obj.options_optim.shrink_mutation = 0.5;
    
else
    
    obj.options_optim = user_opt;
    if ~isfield(obj.options_optim,'n_pop')
        obj.options_optim.n_pop = 200; end
    if ~isfield(obj.options_optim,'max_gen')
        obj.options_optim.max_gen = 200; end
    if ~isfield(obj.options_optim,'fraction_croisement')
        obj.options_optim.fraction_croisement = 2/obj.prob.m_x; end
    if ~isfield(obj.options_optim,'ratio_croisement')
        obj.options_optim.ratio_croisement = 1.2; end
    if ~isfield(obj.options_optim,'fraction_mutation')
        obj.options_optim.fraction_mutation = 2/obj.prob.m_x; end
    if ~isfield(obj.options_optim,'scale_mutation')
        obj.options_optim.scale_mutation = 0.1; end
    if ~isfield(obj.options_optim,'shrink_mutation')
        obj.options_optim.shrink_mutation = 0.5; end
    
end

obj.options_optim.lb = obj.prob.lb;
obj.options_optim.ub = obj.prob.ub;


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


