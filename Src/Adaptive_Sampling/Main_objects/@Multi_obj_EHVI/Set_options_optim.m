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

