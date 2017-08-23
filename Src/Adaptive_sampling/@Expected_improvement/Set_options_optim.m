function [] = Set_options_optim( obj, user_opt )
%SET_OPTIONS_OPTIM Set options for optimization
%   User defined or basic options

if isempty(obj.g_ind)
    
    if isempty(user_opt)
        
        obj.options_optim.TolX = 1e-4; %Tolerance on final optimized input
        obj.options_optim.TolFun = 1e-4; %Tolerance on final optimized output
        obj.options_optim.DispModulo = 0; % Display message or not during optimization
        obj.options_optim.Restarts = 2; % Number of restar of the algorithm

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
    
else
    
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

end

