classdef Expected_improvement < Adaptive_sampling
    % EXPECTED_IMPROVEMENT 
    % Efficient Global Optimization algorithm.
    % Single objective kriging (or cokriging) based optimization method.
    % Constrained or unconstrained problems.
    
    properties
        
        meta_type         
        options_optim  % Structure of user optimization options
        QV_val = [];   % Value of qualitative variable if needed
        
        EI_val         % Expected improvement value at current iteration
        conv_crit      % Adpative sampling criterion value
        in_a_row       % Number of valid criterion value in a row
        
        
    end
    
    properties(Constant)
        Tol_conv = 1e-4; % Convergence tolerance on EI/y_min ratio.
        Tol_inarow = 3;  % Successive tolerance success
    end
    
    methods
        
        function obj = Expected_improvement(prob, y_ind, g_ind, meta_type ,varargin)
            p = inputParser;
            p.KeepUnmatched = true;
            p.PartialMatching = false;
            p.addRequired('meta_type',@(x)isequal(x,@Kriging)||isequal(x,@Cokriging)||isequal(x,@Q_kriging));
            p.addOptional('options_optim',[],@(x)isstruct(x));
            p.parse(meta_type,varargin{:})
            in = p.Results;
            unmatched = [fieldnames(p.Unmatched),struct2cell(p.Unmatched)];
            unmatched = unmatched';
            
            % Superclass constructor
            obj@Adaptive_sampling(prob,y_ind,g_ind,unmatched{:});
            
            % Store
            obj.options_optim = in.options_optim;
            obj.meta_type = in.meta_type;
            
            % Checks
            assert( obj.m_y == 1,...
                'SBDOT:Error_prediction:y_index',...
                'Only one objective can be used in Expected_improvement');
            
            % Set optimization options
            obj.Set_options_optim( obj.options_optim );
            
            % Train metamodel            
            metamodel_int_y = ...
                obj.meta_type(obj.prob, obj.y_ind, [], obj.unmatched_params{:});
            
            obj.meta_y = metamodel_int_y;

            
            if obj.m_g >= 1
                for i = 1 : obj.m_g
                    metamodel_int_g(i,:) = ...
                        obj.meta_type(obj.prob, [], obj.g_ind(i), obj.unmatched_params{:});
                end
                obj.meta_g = metamodel_int_g;
            end        
                        
            % Launch optimization sequence
            obj.in_a_row = 0;
            obj.Opt();
            
            
        end
        
        
        [] = Set_options_optim( obj, user_opt );
        [] = Conv_check_crit( obj );    
        [] = Opt_crit( obj );
        [ EI_val ] = EI_unconstrained( obj, x_test );
        [ EI_val, cons ] = EI_constrained( obj, x_test );
        
    end  
    
end

