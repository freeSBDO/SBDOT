function opts = Def_hyp_corr( obj , type, opts , clean )
% DEF_HYP set the hyperparameter variables before training
%
% Syntax :
% []=obj.Def_hyp_corr(type);

switch type    
    case 'HF'
        i_var = 2;
    case 'LF'
        i_var = 1;
    otherwise
        error('SBDOT:Cokriging:WrongTypeDefHyp','Type for Def_hyp_corr method must be LF or HF')
end

if isempty(obj.hyp_corr{i_var})
    
    % Default bounds
    if isempty( obj.lb_hyp_corr{i_var} ) || isempty( obj.ub_hyp_corr{i_var} )
        
        if xor( isempty(obj.lb_hyp_corr{i_var}), isempty(obj.ub_hyp_corr{i_var}) )
            warning('SBDOT:Cokriging:HypBounds_miss','Both bounds lb_hyp_corr and ub_hyp_corr have to be defined ! Default values are applied')
        end
        
        % Bounds based on inter-distances of training points
        [ hyp_corr0_temp, lb_hyperp_temp, ub_hyperp_temp ] = Theta_bound_normal( obj.x_train{i_var} );
        obj.lb_hyp_corr{i_var} = log10( ( 1./(sqrt(2)*ub_hyperp_temp) ).^2 );
        obj.ub_hyp_corr{i_var} = log10( ( 1./(sqrt(2)*lb_hyperp_temp) ).^2 );
        
        if isempty(obj.hyp_corr0{i_var})
            
            obj.hyp_corr0{i_var} = log10( ( 1./(sqrt(2)*hyp_corr0_temp) ).^2 );
        
        else
            
            assert( size(obj.hyp_corr0{i_var},2) == obj.prob.m_x ,...
            'SBDOT:Cokriging:Hyp0_size',...
            'hyp_corr0 must be of size 1-by-m_x');
            
            obj.hyp_corr0{i_var} = log10( obj.hyp_corr0{i_var} );
            
        end
        
    else
        
        assert( size(obj.lb_hyp_corr{i_var},2) == obj.prob.m_x ,...
            'SBDOT:Cokriging:HypBounds_size',...
            'lb_hyp_corr must be of size 1-by-m_x');
        
        assert( size(obj.ub_hyp_corr{i_var},2) == obj.prob.m_x ,...
            'SBDOT:Cokriging:HypBounds_size',...
            'ub_hyp_corr must be of size 1-by-m_x');
        
        assert( all( obj.lb_hyp_corr{i_var} < obj.ub_hyp_corr{i_var} , 2),...
            'SBDOT:Cokriging:HypBounds',...
            'lb_hyp_corr must be lower than ub_hyp_corr');
        
        obj.ub_hyp_corr{i_var} = log10( obj.ub_hyp_corr{i_var} );
        obj.lb_hyp_corr{i_var} = log10( obj.lb_hyp_corr{i_var} );
        obj.hyp_corr0{i_var} = ( obj.lb_hyp_corr{i_var} + obj.ub_hyp_corr{i_var} ) ./ 2;
        
    end
    
else
    
    assert( size(obj.hyp_corr{i_var},2) == obj.prob.m_x ,...
            'SBDOT:Cokriging:Hyp_val_size',...
            'hyp_corr0 must be of size 1-by-m_x');
        
    obj.hyp_corr0{i_var} = log10(obj.hyp_corr{i_var});
    obj.lb_hyp_corr{i_var} = log10(obj.hyp_corr{i_var});
    obj.ub_hyp_corr{i_var} = log10(obj.hyp_corr{i_var});
        
end

opts.regressionMaxLevelInteractions = obj.prob.m_x;
opts.hpLikelihood{i_var} = obj.estim_hyp{i_var};

if isequal( obj.estim_hyp{i_var}, @pseudoLikelihood )
    optimopt.GradObj = 'off';
    optimopt.MaxIterations = 2000;
    optimopt.MaxFunctionEvaluations = 2000;
    optimopt.StepTolerance = 1e-10;
    opts.hpOptimizer{i_var} = ooDACE.MatlabOptimizer( 1,1, optimopt );
end

if obj.go_opt{i_var}
    optimopt.TolX = 1e-4;
    optimopt.Restarts = 0;
    optimopt.IncPopSize = 1;
    optimopt.TolFun = 1e-4;
    optimopt.DispModulo = 0;
    opts.hpOptimizer{i_var} = ooDACE.CmaesOptimizer( 1,1, optimopt );
end

% Regression (if asked)
if obj.reg{i_var} 
    
    if obj.prob.display, fprintf('\nRegression activated\n');end
    
    if isempty(obj.hyp_reg{i_var} )            
        
        if isempty( obj.lb_hyp_reg{i_var}  ) || isempty( obj.ub_hyp_reg{i_var}  )
            
            if xor( isempty(obj.lb_hyp_reg{i_var} ), isempty(obj.ub_hyp_reg{i_var} ) )
                warning('SBDOT:Cokriging:RegBounds_miss','Both bounds lb_reg and ub_reg have to be defined ! Default values are applied')
            end
            obj.lb_hyp_reg{i_var}  = 1e-8;
            obj.ub_hyp_reg{i_var}  = max( var(obj.f_train{i_var} ), 1e-7 );
            
        else
            
            assert( all( obj.lb_hyp_reg{i_var}  < obj.ub_hyp_reg{i_var}  , 2),...
                'SBDOT:Cokriging:RegBounds',...
                'lb_hyp_reg must be lower than ub_hyp_reg');
            
        end
        
        opts.reinterpolation{i_var} = true;
        
        opts.lambda0{i_var} = log10( (obj.lb_hyp_reg{i_var} + obj.ub_hyp_reg{i_var}) / 2 );
        
        opts.lambdaBounds{i_var} = log10([obj.lb_hyp_reg{i_var} ; obj.ub_hyp_reg{i_var}]);
        
    else
        
        opts.lambda0{i_var} = log10( obj.hyp_reg{i_var} );
        obj.lb_hyp_reg{i_var} = log10( obj.hyp_reg{i_var} );
        obj.ub_hyp_reg{i_var} = log10( obj.hyp_reg{i_var} );
        opts.lambdaBounds{i_var} = log10( [obj.hyp_reg{i_var} ; obj.hyp_reg{i_var}] );
        
    end
end

end

