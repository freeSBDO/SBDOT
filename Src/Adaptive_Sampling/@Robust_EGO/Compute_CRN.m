function [] = Compute_CRN( obj )
% COMPUTE_CRN
%

obj.CRN_matrix = ones( obj.CRN_samples, obj.prob.m_x );

% Random sampling for correlated inputs
if ~isempty(obj.cor_lab) 
    
    rand_uni_cor = rand( obj.CRN_samples, 1 );
    rand_gauss_cor = Rand_gauss( obj.CRN_samples, 1, 0, 0.033333 );
    
end

for i = 1:obj.prob.m_x
    
    % initialize test for classic uncertainty variable
    test_classic = 0; 
    switch obj.unc_type{i} % type of uncertainty
        case 'uni'
            
            % correlated
            if obj.cor_lab(i) 
                rand_uni1 = rand_uni_cor;
            else
                rand_uni1 = rand( obj.CRN_samples, 1 );
            end
            
            % photonic type
            if obj.phot_lab(i) 
                
                test_classic = 1;
                rand_uni2 = (rand_uni1 * 0.2) - 0.1;
                obj.lb_rob(1,i) = 1.1 * obj.prob.lb(i);
                obj.ub_rob(1,i) = 0.9 * obj.prob.ub(i);
                
            else                
                rand_uni2 = ( rand_uni1*obj.unc_var(i) ) - (obj.unc_var(i)/2);
            end
            
            % Environnemental
            if obj.env_lab(i) 
                test_classic = 1;
                CRN_column = rand_uni2 + (obj.prob.lb(i) + obj.prob.ub(i))/2;
            else
                CRN_column = rand_uni2;
            end
            
            % Classic
            if test_classic == 0 
                
                obj.classic_lab(i) = 1;
                obj.lb_rob(1,i) = obj.prob.lb(i) + obj.unc_var(i)/2;
                obj.ub_rob(1,i) = obj.prob.ub(i) - obj.unc_var(i)/2;
                
            end
            
        case 'gauss'
            
            % correlated
            if obj.cor_lab(i) 
                rand_gauss1 = rand_gauss_cor;
            else
                rand_gauss1 = Rand_gauss( obj.CRN_samples, 1, 0, 0.033333 );
            end
            
            % photonic type
            if obj.phot_lab(i) 
                
                test_classic = 1;
                rand_gauss2 = rand_gauss1;
                obj.lb_rob(1,i) = 1.1*obj.prob.lb(i);
                obj.ub_rob(1,i) = 0.9*obj.prob.ub(i);
                
            else
                % min and max =  -+obj.unc_var
                rand_gauss2 = rand_gauss1*5*obj.unc_var(i);                 
            end
            
            % Environnemental
            if obj.env_lab(i) 
                test_classic=1;
                CRN_column = rand_gauss2 + (obj.prob.lb(i) + obj.prob.ub(i))/2;
            else
                CRN_column = rand_gauss2;
            end
            
            % Classic
            if test_classic == 0 
                
                obj.classic_lab(i) = 1;
                obj.lb_rob(1,i)=obj.prob.lb(i) + obj.unc_var(i)/2;
                obj.ub_rob(1,i)=obj.prob.ub(i) - obj.unc_var(i)/2;
                
            end
            
        case 'det'
            
            obj.det_lab(i) = 1;
            CRN_column = zeros(obj.CRN_samples,1);
            obj.lb_rob(1,i)=obj.prob.lb(i);
            obj.ub_rob(1,i)=obj.prob.ub(i);
            
        otherwise
            error('wrong uncertainty type for correlated variable, check robust_def.unc_type variable')
    end
    
    obj.CRN_matrix(:,i) = CRN_column;
    
end


end

