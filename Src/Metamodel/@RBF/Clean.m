function [] = Clean( obj , type )
%CLEAN Delete some parameter variables for re-estimation
% type is a cell of string

if strcmp(type{1},'all')
    type = {'corr'};
end

for i=1:length(type)
    
    switch type{i}
        
        case 'corr'
            
            obj.hyp_corr = [];
            obj.lb_hyp_corr = [];
            obj.ub_hyp_corr = [];
            obj.hyp_corr0 = [];           
            
    end
    
end

end

