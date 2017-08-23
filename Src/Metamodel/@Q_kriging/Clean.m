function [] = Clean( obj , type )
%CLEAN Delete some parameter variables for re-estimation
% type is a cell of string

if strcmp(type{1},'all')
    type = {'corr','reg','sigma2','tau','dchol','Sigma'};
end

for i=1:length(type)
    
    switch type{i}
        
        case 'corr'
            
            obj.hyp_corr = [];
            obj.lb_hyp_corr = [];
            obj.ub_hyp_corr = [];
            obj.hyp_corr_0 = [];
            
        case 'reg'
            
            obj.hyp_reg = [];
            obj.lb_hyp_reg = [];
            obj.ub_hyp_reg = [];
            obj.hyp_reg_0 = [];
            
        case 'sigma2'
            
            obj.hyp_sigma2 = [];
            obj.lb_hyp_sigma2 = [];
            obj.ub_hyp_sigma2 = [];
            obj.hyp_sigma2_0 = [];
              
        case 'tau'
            
            obj.hyp_tau = [];
            obj.lb_hyp_tau = [];
            obj.ub_hyp_tau = [];
            obj.hyp_tau_0 = [];
        
        case 'dchol'
            
            obj.hyp_dchol = [];
            obj.lb_hyp_dchol = [];
            obj.ub_hyp_dchol = [];
            obj.hyp_dchol_0 = [];
            
        case 'Sigma'
            
            obj.Sigma = [];
            
    end
    
end

end

