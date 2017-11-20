classdef CORS_RBF < Adaptive_sampling
    % CORS_RBF
    % Gutmann optimization algorithm with RBF
    % Single objective RBF (or co-RBF) based optimization method.
    % unconstrained or constrained problems.
    % 
    % obj = CORS_RBF(prob, y_ind, g_ind, meta_type, varargin)
    %    
    % Mandatory inputs :
    %   - problem is a Problem/Problem_multifi object, created with the appropriate class constructor
    %   - y_ind is the index of the objective to optimize
    %   - g_ind is the index of the constraint(s) to take into account
    %   - meta_type is the type of metamodel to use (@RBF or @CoRBF)
    %
    % Optional inputs [default value]:
    %   - 'distance_factor' parameter for the trade-off between exploration and explotation
    %   Decreasing numbers in ]1;0]. The length of the vector is the cycle length
    %   [0.9 0.75 0.25 0.05 0.03 0]
    %   - 'options_optim' is a structure for optimization of Gutmann criterion
    %   see Set_options_optim for example of parameters structure
    %   * Optional inputs for RBF or CoRBF apply
    %   * Optional inputs for Adaptive_sampling apply
    %
    
    properties
        
        % Mandatory inputs
        meta_type       % Type of metamodel 
        
        % Optional inputs
        options_optim   % Structure of user optimization options
        distance_factor % Beta_N factor for minimum distance to sampling points        
        
        % Computed variables  
        cycle_length    % Cycle length (number of elements in distance_factor)
        n0              % Number of initial points in the DOE
        delta_mm        % Maximin distance with training points over design space
        beta_n          % Maximin distance with training points over design space
        k_n             % Current iteration number in the cycle
        cors_val        % Optimization criterion value at current iteration
        
    end
    
    methods
        
        function obj = CORS_RBF(prob, y_ind, g_ind, meta_type ,varargin)
            p = inputParser;
            p.KeepUnmatched = true;
            p.PartialMatching = false;
            p.addRequired('meta_type',@(x)isequal(x,@RBF)||isequal(x,@CoRBF));
            p.addOptional('options_optim',[],@(x)isstruct(x));
            p.addOptional('distance_factor',[0.9 0.75 0.25 0.05 0.03 1e-3],@(x)(isrow(x)&&isnumeric(x)));
            p.parse(meta_type,varargin{:})
            in = p.Results;
            unmatched = [fieldnames(p.Unmatched),struct2cell(p.Unmatched)];
            unmatched = unmatched';
            
            % Superclass constructor
            obj@Adaptive_sampling(prob,y_ind,g_ind,unmatched{:});
            
            % Store
            obj.options_optim = in.options_optim;
            obj.meta_type = in.meta_type;
            obj.distance_factor = in.distance_factor;
            
            obj.cycle_length = length(obj.distance_factor);
            
            % Checks
            assert( obj.m_y == 1,...
                'SBDOT:Error_prediction:y_index',...
                'Only one objective can be used in Gutmann_RBF');
            
            % Set optimization options
            obj.Set_options_optim( obj.options_optim );
            if isa( obj.prob, 'Problem' )
                obj.n0 = obj.prob.n_x;
            else
                obj.n0 = obj.prob.prob_HF.n_x;
            end
            
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
                       
        end
        
        [] = Set_options_optim( obj, user_opt );
        [] = Conv_check_crit( obj );
        [] = Opt_crit( obj );
        [] = Find_min_value( obj );
        [ y_pred ] = Prediction( obj, x );
        [ crit ] = Gutmann_crit( obj, x, min_target );
        
    end
    
end

