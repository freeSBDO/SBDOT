function [] = Def_hyp_corr( obj )
% DEF_HYP 
%   Set the hyperparameter variables before training
%

i_var = 2; % HF def only for CoRBF 

% Correlation length
if isempty(obj.hyp_corr{i_var})
    
    % Default bounds
    if isempty( obj.lb_hyp_corr{i_var} ) || isempty( obj.ub_hyp_corr{i_var} )
        
        if xor( isempty(obj.lb_hyp_corr{i_var}), isempty(obj.ub_hyp_corr{i_var}) )
            warning('SBDOT:CoRBF:HypBounds_miss','Both bounds lb_hyp_corr and ub_hyp_corr have to be defined ! Default values are applied')
        end
        
        % Bounds based on inter-distances of training points
        [ hyp_corr0_temp, lb_hyperp_temp, ub_hyperp_temp ] = Theta_bound( obj.x_train{i_var} );
        obj.lb_hyp_corr{i_var} = log10( ( 1./(sqrt(2)*ub_hyperp_temp) ).^2 );
        obj.ub_hyp_corr{i_var} = log10( ( 1./(sqrt(2)*lb_hyperp_temp) ).^2 );
        
        if isempty(obj.hyp_corr0{i_var})
            
            obj.hyp_corr0{i_var} = log10( ( 1./(sqrt(2)*hyp_corr0_temp) ).^2 );
        
        else
            
            assert( size(obj.hyp_corr0{i_var},2) == obj.prob.m_x ,...
            'SBDOT:CoRBF:Hyp0_size',...
            'hyp_corr0 must be of size 1-by-m_x');
            
            obj.hyp_corr0{i_var} = log10( obj.hyp_corr0{i_var} );
            
        end
        
    else
        
        assert( size(obj.lb_hyp_corr{i_var},2) == obj.prob.m_x ,...
            'SBDOT:CoRBF:HypBounds_size',...
            'lb_hyp_corr must be of size 1-by-m_x');
        
        assert( size(obj.ub_hyp_corr{i_var},2) == obj.prob.m_x ,...
            'SBDOT:CoRBF:HypBounds_size',...
            'ub_hyp_corr must be of size 1-by-m_x');
        
        assert( all( obj.lb_hyp_corr{i_var} < obj.ub_hyp_corr{i_var} , 2),...
            'SBDOT:CoRBF:HypBounds',...
            'lb_hyp_corr must be lower than ub_hyp_corr');
        
        obj.ub_hyp_corr{i_var} = log10( obj.ub_hyp_corr{i_var} );
        obj.lb_hyp_corr{i_var} = log10( obj.lb_hyp_corr{i_var} );
        obj.hyp_corr0{i_var} = ( obj.lb_hyp_corr{i_var} + obj.ub_hyp_corr{i_var} ) ./ 2;
        
    end
    
else
    
    assert( size(obj.hyp_corr{i_var},2) == obj.prob.m_x ,...
            'SBDOT:CoRBF:Hyp_val_size',...
            'hyp_corr0 must be of size 1-by-m_x');
        
    obj.hyp_corr0{i_var} = log10(obj.hyp_corr{i_var});
    obj.lb_hyp_corr{i_var} = log10(obj.hyp_corr{i_var});
    obj.ub_hyp_corr{i_var} = log10(obj.hyp_corr{i_var});
        
end

% Scaling factor
if isempty(obj.rho) 
    if isempty( obj.lb_rho ) || isempty( obj.ub_rho )
        
        if xor( isempty(obj.lb_rho), isempty(obj.ub_rho) )
            warning('SBDOT:CoRBF:rhoBounds_miss','Both bounds lb_rho and ub_rho have to be defined ! Default values are applied')
        end
        
        y_max = [max(obj.f_train{1}),max(obj.f_train{2})];
        y_min = [min(obj.f_train{2}),min(obj.f_train{1})];
        
        obj.lb_rho=-max(abs(y_max-y_min));
        obj.ub_rho=max(abs(y_max-y_min));
                
        if isempty(obj.rho0)            
            obj.rho0 = abs(max(obj.f_train{1})-min(obj.f_train{2}));        
        else
            
            assert( size(obj.rho0,2) == 1 ,...
            'SBDOT:CoRBF:rho0_size',...
            'rho0 must be of size 1-by-1');
            
            obj.hyp_corr0{i_var} = log10( obj.hyp_corr0{i_var} );
            
        end
        
    else
        
        assert( size(obj.lb_rho,2) == 1 ,...
            'SBDOT:CoRBF:rhoBounds_size',...
            'lb_rho must be of size 1-by-1');
        
        assert( size(obj.ub_rho,2) == 1 ,...
            'SBDOT:CoRBF:rhoBounds_size',...
            'ub_rho must be of size 1-by-1');
        
        assert( all( obj.lb_rho < obj.ub_rho , 2),...
            'SBDOT:CoRBF:rhoBounds',...
            'lb_rhor must be lower than ub_rho');
        
        if isempty(obj.rho0)            
            obj.rho0 = ( obj.ub_rho + obj.lb_rho ) ./ 2;  
        end
        
    end
    
else
    
    obj.lb_rho=obj.rho;
    obj.ub_rho=obj.rho;
    obj.rho0=obj.rho;
    
end

end

