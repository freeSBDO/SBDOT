classdef Multi_obj_EI_MGDA < Adaptive_sampling
    % MULTI_OBJ_EI_MGDA 
    % Kriging-based MGDA
    
    properties
        
        meta_type
        options_optim  % Structure of user optimization options
        N_eval         % Number of points to evaluate at each iteration.
        % Set N_eval to Inf for a good calibration
        
        conv_crit      % Adpative sampling criterion value
        in_a_row       % Number of valid criterion value in a row
        
        y_pareto_temp % Pareto front from problem values
        y_ref_temp    % Reference point for hypervolume computation
        n_Q_val       % Number of values of combination of qualitative variable
        
    end
    
    properties(Constant)
        Tol_inarow = 3;  % Successive tolerance success
    end
    
    methods
        
        function obj = Multi_obj_EI_MGDA(prob, y_ind, g_ind, meta_type, N_eval ,varargin)
           
            p = inputParser;
            p.KeepUnmatched = true;
            p.PartialMatching = false;
            p.addRequired('meta_type',@(x)isequal(x,@Kriging)||isequal(x,@Cokriging)||isequal(x,@Q_kriging));
            p.addRequired('N_eval',@(x)isnumeric(x));
            p.addOptional('options_optim',[],@(x)isstruct(x));
            p.parse(meta_type,N_eval,varargin{:})
            in = p.Results;
            unmatched = [fieldnames(p.Unmatched),struct2cell(p.Unmatched)];
            unmatched = unmatched';
            
            % Superclass constructor
            obj@Adaptive_sampling(prob,y_ind,g_ind,unmatched{:});
            
            % Store
            obj.options_optim = in.options_optim;
            obj.meta_type = in.meta_type;
            obj.N_eval = in.N_eval;
            
            
            % Checks
            assert( obj.m_y > 1 || ( isequal(meta_type,@Q_kriging) && obj.m_y == 1 && obj.m_g == 0), ...
                'SBDOT:Multi_obj_EI_MGDA:y_ind', ...
                horzcat('y_ind must be composed of at least 2 elements (multi-objective optimization)',...
                ' or prob must be a qualitative problem with 1 objective and no constraint (multi-modality optimization)'));
            
            % Set optimization options
            obj.Set_options_optim( obj.options_optim );
            
            % Train metamodel
            if isequal(meta_type,@Q_kriging)
                
                obj.meta_y = obj.meta_type(obj.prob, obj.y_ind, [], obj.unmatched_params{:});
                
            else
                
                for i=1:obj.m_y
                    metamodel_int_y(i,:) = ...
                        obj.meta_type(obj.prob, obj.y_ind(i), [], obj.unmatched_params{:});
                end
                
                obj.meta_y = metamodel_int_y;
                
            end
            
            % Launch optimization sequence
            obj.in_a_row = 0;
            obj.Opt();
            
        end
        
        [] = Conv_check_crit( obj );
        [] = Find_min_value( obj );
        [ EI_val, grad_EI ] = Obj_func_EI( obj, x_test );
        [ y_obj ] = Obj_func_nsga( obj, x_test );
        [] = Opt_crit( obj );
        [] = Set_options_optim( obj, user_opt );        
        
    end
    
end

