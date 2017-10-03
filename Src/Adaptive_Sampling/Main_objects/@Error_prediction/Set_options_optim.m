function [] = Set_options_optim( obj, user_opt )
%SET_OPTIONS_OPTIM Set options for optimization
%   User defined or basic options

if isempty(user_opt)
    obj.options_optim.TolX = 1e-4; %Tolerance on final optimized input
    obj.options_optim.TolFun = 1e-4; %Tolerance on final optimized output
    obj.options_optim.DispModulo = 0; % Display message or not during optimization
    obj.options_optim.Restarts = 4; % Number of restar of the algorithm
    if strcmp(obj.crit_type,'MSE')
        obj.options_optim.EvalParallel = 'yes'; % Evaluate multiple points at the time
    else
        obj.options_optim.EvalParallel = 'no'; % Evaluate multiple points at the time
    end
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

