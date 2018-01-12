function [] = Set_options_optim( obj, user_opt )
%SET_OPTIONS_OPTIM Set options for optimization
%   User defined or basic options
%   options_optim1 is for EI optimization
%   options_optim2 is for environmental parameters selection before evaluation

if isempty(obj.g_ind)
    
    if isempty(user_opt)
        
        obj.options_optim1.TolX = 1e-4; %Tolerance on final optimized input
        obj.options_optim1.TolFun = 1e-4; %Tolerance on final optimized output
        obj.options_optim1.DispModulo = 0; % Display message or not during optimization
        obj.options_optim1.Restarts = 3; % Number of restar of the algorithm
        
    else
        
        obj.options_optim1 = user_opt.options1;
        if ~isfield(obj.options_optim1,'TolX')
            obj.options_optim1.TolX = 1e-4; end
        if ~isfield(obj.options_optim1,'TolFun')
            obj.options_optim1.TolFun = 1e-4; end
        if ~isfield(obj.options_optim1,'DispModulo')
            obj.options_optim1.DispModulo = 0; end
        if ~isfield(obj.options_optim1,'Restarts')
            obj.options_optim1.Restarts = 3; end
        if ~isfield(obj.options_optim1,'EvalParallel')
            obj.options_optim1.EvalParallel = 'no'; end
        
    end
    
    obj.options_optim1.LBounds = obj.lb_rob;
    obj.options_optim1.UBounds = obj.ub_rob;
    
else
    
    if isempty(user_opt)
        
        obj.options_optim1.n_pop = 200;
        obj.options_optim1.max_gen = 200;
        obj.options_optim1.fraction_croisement = 2/obj.prob.m_x;
        obj.options_optim1.ratio_croisement = 1.2;
        obj.options_optim1.fraction_mutation = 2/obj.prob.m_x;
        obj.options_optim1.scale_mutation = 0.1;
        obj.options_optim1.shrink_mutation = 0.5;
        
    else
        
        obj.options_optim1 = user_opt;
        if ~isfield(obj.options_optim1,'n_pop')
            obj.options_optim1.n_pop = 200; end
        if ~isfield(obj.options_optim1,'max_gen')
            obj.options_optim1.max_gen = 200; end
        if ~isfield(obj.options_optim1,'fraction_croisement')
            obj.options_optim1.fraction_croisement = 2/obj.prob.m_x; end
        if ~isfield(obj.options_optim1,'ratio_croisement')
            obj.options_optim1.ratio_croisement = 1.2; end
        if ~isfield(obj.options_optim1,'fraction_mutation')
            obj.options_optim1.fraction_mutation = 2/obj.prob.m_x; end
        if ~isfield(obj.options_optim1,'scale_mutation')
            obj.options_optim1.scale_mutation = 0.1; end
        if ~isfield(obj.options_optim1,'shrink_mutation')
            obj.options_optim1.shrink_mutation = 0.5; end
        
    end
    
    obj.options_optim1.lb = obj.lb_rob;
    obj.options_optim1.ub = obj.ub_rob;
    
end

if isempty(user_opt)
    
    obj.options_optim2.TolX = 1e-4; %Tolerance on final optimized input
    obj.options_optim2.TolFun = 1e-4; %Tolerance on final optimized output
    obj.options_optim2.DispModulo = 0; % Display message or not during optimization
    obj.options_optim2.Restarts = 2; % Number of restar of the algorithm
    obj.options_optim2.EvalParallel='yes'; % Evaluate multiple points at the time
    
else
    
    obj.options_optim2 = user_opt.options2;
    if ~isfield(obj.options_optim2,'TolX')
        obj.options_optim2.TolX = 1e-4; end
    if ~isfield(obj.options_optim2,'TolFun')
        obj.options_optim2.TolFun = 1e-4; end
    if ~isfield(obj.options_optim2,'DispModulo')
        obj.options_optim2.DispModulo = 0; end
    if ~isfield(obj.options_optim2,'Restarts')
        obj.options_optim2.Restarts = 1; end
    if ~isfield(obj.options_optim2,'EvalParallel')
        obj.options_optim2.EvalParallel = 'yes'; end
    
end

obj.options_optim2.LBounds = obj.prob.lb(obj.env_lab);
obj.options_optim2.UBounds = obj.prob.ub(obj.env_lab);

obj.options_optim3 = obj.options_optim2;
obj.options_optim3.LBounds = obj.lb_rob;
obj.options_optim3.UBounds = obj.ub_rob;

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


