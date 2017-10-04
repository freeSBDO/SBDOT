classdef Robust_EGO < Adaptive_sampling
    % ROBUST_EGO 
    % Efficient Global Robust Optimization algorithm.
    % Single objective kriging based optimization method.
    % Constrained or unconstrained problems.
    %
    % obj = Robust_EGO(prob, y_ind, g_ind, meta_type, robust_def, CRN_samples, varargin)
    %
    % Mandatory inputs :
    %   - prob is a Problem/Problem_multifi object, created with the appropriate class constructor
    %   - y_ind is the index of the objective to optimize
    %   - g_ind is the index of the constraint(s) to take into account
    %   - meta_type is the type of metamodel to use (@Kriging or @Cokriging)
    %   - robust_def is a structure composed of maximum 7 elements
    %   * env_lab, cor_lab, phot_lab, unc_type, unc_var, meas_type_y, meas_type_g
    %   - CRN_samples is the number of Common Random Numbers Monte Carlo samples (500 is a good first value)
    %   
    % More information for robust_def (see also Compute_CRN method help) :
    %   * env_lab is a boolean row vector of size m_x which is true when
    %   the parameter is environmental 
    %   * cor_lab is a boolean row vector of size m_x which is true when
    %   the parameter is directly correlated to another parameter 
    %   * phot_lab is a boolean row vector of size m_x which is true when
    %   the parameter is "a photonic variable". it means that the
    %   uncertainty interval correspond to 10% of the nominal value
    %   * unc_type is a cell row vector of size m_x with the type of
    %   uncertainty of the parameter ( 'det' for deterministic, 'uni' for
    %   uniform, 'gauss' for gaussian )
    %   * unc_var is a row vector of size m_x which corresponds to the
    %   maximum realization of the random variable. For example, for the
    %   gaussian uncertainty type, it corresponds to the famous "3 sigma".    %   
    %   * meas_type_y is the robustness measure for the objective ('Mean_meas',
    %   'Var_meas', 'Worstcase_meas', 'Mixed_meas')
    %   * meas_type_y (optional) is the robustness measure for the
    %   constraints
    %
    % Optional inputs [default value]:
    %   - 'options_optim' is a structure for optimization of EI criterion
    %   see Set_options_optim for example of parameters structure
    %   * Optional inputs for Kriging apply
    %   * Optional inputs for Adaptive_sampling apply
    %
    
    
    properties
        CRN_samples % Number of samples to estimate robustness measure
        meta_type   % Metamodel type      
        options_optim  % Structure of user optimization options   
        
        env_lab     % Logical row, true for environnemental variables
        cor_lab     % Logical row, true for correlated variables
        phot_lab    % Logical row, true for photonic type variables
        classic_lab % Logical row, true for classical type variables
        det_lab     % Logical row, true for deterministic variables
        fmin_opt    % Logical scalar, fmin obtained by optimization of the response surface
        
        unc_type % Cell row with string about uncertainty type
        unc_compute % String variable with method to compute robust measure
        unc_var % Row with uncertainty standard deviation for each variable
        
        lb_rob % Lower bounds knowning uncertainties
        ub_rob % Upper bounds knowning uncertainties
        
        meas_type_y % String with the name of the robust measure
        meas_type_g % String with the name of the robust measure
        
        CRN_matrix % Matrix generated containing uncertainty information
        
        options_optim1
        options_optim2
        options_optim3
        
        EI_val
        conv_crit
        in_a_row
        
    end
    
    properties(Constant)
        Tol_conv=1e-4; % Convergence tolerance on EI/y_min ratio.
        Tol_inarow=3; % Successive tolerance success
    end
    
    methods
        
        function obj = Robust_EGO(prob,y_ind,g_ind,meta_type,robust_def,CRN_samples,varargin)
            p = inputParser;
            p.KeepUnmatched = true;
            p.PartialMatching = false;
            p.addRequired('meta_type',@(x)isequal(x,@Kriging)||isequal(x,@Cokriging)||isequal(x,@Q_kriging));
            p.addRequired('robust_def',@(x)isstruct(x));
            p.addRequired('CRN_samples',@(x)isnumeric(x));
            p.addOptional('options_optim',[],@(x)isstruct(x));
            p.parse(meta_type,robust_def,CRN_samples,varargin{:})
            in = p.Results;
            unmatched = [fieldnames(p.Unmatched),struct2cell(p.Unmatched)];
            unmatched = unmatched';
            
            % Superclass constructor
            obj@Adaptive_sampling(prob,y_ind,g_ind,unmatched{:});
            
            % Store
            obj.options_optim = in.options_optim;
            obj.meta_type = in.meta_type;
            obj.CRN_samples = in.CRN_samples;
            
            % Logical variable for type identification
            obj.env_lab = logical(in.robust_def.env_lab);
            obj.cor_lab = logical(in.robust_def.cor_lab);
            obj.phot_lab = logical(in.robust_def.phot_lab);
            obj.classic_lab = false(1,obj.prob.m_x);
            obj.det_lab = false(1,obj.prob.m_x);
            % Probabilistic type information
            obj.unc_type = in.robust_def.unc_type;
            % Uncertainty information (variance per variable)
            obj.unc_var = in.robust_def.unc_var;
            % Objective, constraint and error measure settings
            obj.meas_type_y = str2func(in.robust_def.meas_type_y);
            if obj.m_g > 0
                obj.meas_type_g = str2func(in.robust_def.meas_type_g);
            else
                obj.meas_type_g=[];
            end
            
            % Build CRN matrix
            obj.Compute_CRN();
            
            % Train metamodel
            for i = 1 : obj.m_y
                metamodel_int_y(i,:) = ...
                    obj.meta_type(obj.prob, obj.y_ind(i), [], obj.unmatched_params{:});
            end
            
            obj.meta_y = metamodel_int_y;
            
            if obj.m_g >= 1
                for i = 1 : obj.m_g
                    metamodel_int_g(i,:) = ...
                        obj.meta_type(obj.prob, [], obj.g_ind(i), obj.unmatched_params{:});
                end
                obj.meta_g = metamodel_int_g;
            end
            
            % Set optimization options
            obj.Set_options_optim( obj.options_optim );
            
            % Initialize history storage
            obj.hist.x_min_prob=[];
            obj.hist.y_min_prob=[];
            obj.hist.g_min_prob=[];
            obj.hist.x_min_opt=[];
            obj.hist.y_min_opt=[];
            obj.hist.g_min_opt=[];
            
            % Launch optimization sequence
            obj.in_a_row = 0;
            obj.Opt();
            
        end
        
        [] = Compute_CRN( obj )
        [] = Conv_check_crit( obj )
        [ EI_val, cons ] = EI_constrained( obj, x_test )
        [ EI_val ] = EI_unconstrained( obj, x_test )
        [ y_rob, mse_y_rob, g_rob, mse_g_rob ] = Eval_rob_meas( obj, x_test )
        [] = Find_min_value_opt( obj )
        [] = Find_min_value_prob( obj )
        [ meas ] = Mean_meas( obj, data, nb_points )
        [ meas ] = Mixed_meas( obj, data, nb_points )        
        [] = Opt_crit( obj )
        [ obj_val ] = Optim_env( obj, x_env, x_new_rob )
        [ obj_val ] = Optim_meas( obj, x )
        [] = Set_options_optim( obj, user_opt )
        [ x_CRN ] = Update_CRN( obj, x_test )
        [ meas ] = Var_meas( obj, data, nb_points )
        [ meas, id_meas ] = Worstcase_meas( obj, data , nb_points )
        
    end  
    
end

