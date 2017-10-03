function [ LOO ] = Obj_diff_opt( obj, x , yc_e)
%OBJ_DIFF_OPT Summary of this function goes here
%   Detailed explanation goes here

if isempty(obj.hyp_corr{2}) && isempty(obj.rho) 
    hyp_corr_temp = x(2:end);   
    rho_temp = x(1);
elseif isempty(obj.hyp_corr{2}) && ~isempty(obj.rho) 
    hyp_corr_temp = x;
    rho_temp = obj.rho;
elseif ~isempty(obj.hyp_corr{2}) && isempty(obj.rho)
    hyp_corr_temp = obj.hyp_corr{2};
    rho_temp = x;
end

RBF_d_temp = RBF(obj.prob.prob_HF, obj.y_ind, obj.g_ind, ...
    'corr', obj.corr{2} ,'hyp_corr', hyp_corr_temp, 'lb_hyp_corr', obj.lb_hyp_corr{2}, ...
    'ub_hyp_corr', obj.ub_hyp_corr{2}, ...
    'estimator', obj.estimator{2}, 'optimizer', obj.optimizer{2}, ...
    'shift_output',[ones(size(yc_e,1),1) -rho_temp*yc_e]);

LOO = RBF_d_temp.Loo_error(log10(hyp_corr_temp));


end

