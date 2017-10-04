function [] = Clean( obj , type )
% CLEAN
%   Delete some parameter variables for re-estimation
%   - type is a cell of string depending on variables to clean
%   'all', 'corr_HF', 'corr_LF', 'reg_HF', 'reg_LF', 'rho'
%
%   Syntax examples :
%       obj.Clean({'all'});
%       obj.Clean({'corr_HF','corr_LF'});


if strcmp(type{1},'all')
    type = {'corr_HF','corr_HF','reg_HF','reg_LF','rho'};
end


for i=1:length(type)
    
    switch type{i}
        
        case 'corr_HF'
            
            obj.hyp_corr{2} = [];
            obj.lb_hyp_corr{2} = [];
            obj.ub_hyp_corr{2} = [];
            obj.hyp_corr0{2} = [];
            
        case 'corr_LF'
            
            obj.hyp_corr{1} = [];
            obj.lb_hyp_corr{1} = [];
            obj.ub_hyp_corr{1} = [];
            obj.hyp_corr0{1} = [];
            
        case 'reg_HF'
            
            obj.hyp_reg{2} = [];
            obj.lb_hyp_reg{2} = [];
            obj.ub_hyp_reg{2} = [];
            
        case 'reg_LF'
            
            obj.hyp_reg{1} = [];
            obj.lb_hyp_reg{1} = [];
            obj.ub_hyp_reg{1} = [];
            
        case 'rho'
            
            obj.rho = [];
            obj.lb_rho = [];
            obj.ub_rho = [];
            
    end
    
end

end

