classdef Q_kriging < Metamodel
    % QUALITATIVE KRIGING class

    properties (Constant = true)
        
        REG = 1;
        SIGMA2 = 2;
        CORR = 3;
        TAU = 4;
        DCHOL = 5;
        
    end
    
    properties ( Access = public )
        
        % Optional inputs (varargin) 
        regpoly                    % Regression order of Kriging
        reg_max_level_interactions % Maximum level of regression interactions
        corr                       % Correlation function
        reg                        % Boolean to activate regression
        var_opti                   % Boolean to activate extrinsic variance optimisation
        hyp_corr                   % Correlation length parameter
        hyp_reg                    % Kriging regression parameter
        hyp_tau                    % Intra-modality correlation parameter 
        hyp_dchol                  % Heteroskedasticity parameter
        hyp_sigma2                 % Global variance parameter
        hyp_corr_0                 % Correlation length parameter initial value
        hyp_reg_0                  % Kriging regression parameter initial value
        hyp_tau_0                  % Intra-modality correlation parameter initial value
        hyp_dchol_0                % Heteroskedasticity parameter initial value
        hyp_sigma2_0               % Global variance parameter initial value
        lb_hyp_corr                % Lower bound of correlation length parameter
        ub_hyp_corr                % Upper bound of correlation length parameter
        lb_hyp_reg                 % Lower bound of kriging regression parameter
        ub_hyp_reg                 % Upper bound of kriging regression parameter
        lb_hyp_tau                 % Lower bound of Intra-modality correlation parameter
        ub_hyp_tau                 % Upper bound of Intra-modality correlation parameter
        lb_hyp_dchol               % Lower bound of Heteroskedasticity parameter
        ub_hyp_dchol               % Upper bound of Heteroskedasticity parameter
        lb_hyp_sigma2              % Lower bound of Global variance parameter
        ub_hyp_sigma2              % Upper bound of Global variance parameter
        reinterpolation            % Boolean to activate reinterpolation
        tau_type                   % Type of intra-modality correlation matrix
        marginal_likelihood        % Marginal Likelihood function
        optim_method               % Method for Likelihhod Optimization
        
        % Computed variables
        regression_max_order = []; % Regression maximum order
        samples = [];              % Reduced and centered input_scaling (only continuous var)
        values = [];               % Reduced and centered output_scaling
        q_var = [];                % Qualitative values
        input_scaling = [];        % Normalized Input scale
        output_scaling  = [];      % Normalized Ouput scale
        p_tau = [];                % Tau preprocessed to be used in Kernel
        dist = [];                 % Input data manhattan inter-distance
        dist_idx_psi = [];         % Dist Index
        preprocess_tau = [];       % Intra-modality correlation coefficients preprocessed
        optim_idx = [];            % Logical index for hyper-param optimization
        optim_nr_parameters = [];  % Number of optimization parameter(s)
        alpha = [];                % Regression coefficients
        gamma = [];                % Correlation part coefficients
        C = [];                    % Choleski Decomposition of extrinsic + intrinsic matrices
        Sigma = [];                % Intrinsic covariance matrix
        Ft = [];                   % Decorrelated model matrix
        R = [];                    % From QR Decomposition during Regression Fitting
        sigma2_reinterp = [];      % Reinterpolation version of sigma2
        C_reinterp = [];           % Reinterpolation version of C
        Ft_reinterp = [];          % Reinterpolation version of Ft
        R_reinterp = [];           % Reinterpolation version of R
        
    end
    
    methods ( Access = public )

        function obj=Q_kriging(prob,y_ind,g_ind,varargin)
            % Q_kriging constructor (see also Metamodel)
            %
            % Initialized a Q_kriging object with mandatory inputs :
            % 	obj=Q_kriging(prob,y_ind,g_ind)
            %
            % Initialized a problem object with optionnal inputs :
            % 	obj=Q_kriging(prob,y_ind,g_ind,varargin)
            %   obj=Q_kriging(prob,y_ind,g_ind,'regpoly','regpoly0')
            %
            % Optionnal inputs [default value] :
            %   'regpoly'                       ['regpoly0'], 'regpoly1', 'regpoly2', 'regpoly3'
            %   'reg_max_level_interactions'    [2]
            %   'corr'                          ['Q_Matern5_2'], 'Q_Matern3_2', 'Q_gauss'
            %   'reg'                           [false], true
            %   'var_opti'                      [false], true
            %   'hyp_corr'                      [Optimized]    
            %   'hyp_reg'                       [reg = true -> optimized, reg = false -> []]
            %   'hyp_tau'                       [Optimized, depend on tau_type]
            %   'hyp_dchol'                     [tau_type = 'heteroskedastic' -> optimized, else -> []]
            %   'hyp_sigma2'                    [var_opti = true -> Optimized, else -> Auto Calibrate]
            %   'hyp_corr_0'                    [Auto calibrate with training dataset]       
            %   'hyp_reg_0'                     [reg = true -> Auto Calibrate, else -> []]
            %   'hyp_tau_0'                     [Auto calibrate (if hyp_tau not provided)]
            %   'hyp_dchol_0'                   [Unit Vector (if hyp_dchol not provided)]
            %   'hyp_sigma2_0'                  [Auto Calibrate (if hyp_sigma2 is not provided)]
            %   'lb_hyp_corr'                   [Auto calibrate with training dataset]     
            %   'ub_hyp_corr'                   [Auto calibrate with training dataset]          
            %   'lb_hyp_reg'                    [-8]
            %   'ub_hyp_reg'                    [Auto calibrate with training dataset]          
            %   'lb_hyp_tau'                    [if isotropic -> -1/(m_t-1); else -> 0]     
            %   'ub_hyp_tau'                    [if isotropic -> 1; else -> pi]          
            %   'lb_hyp_dchol'                  [0.01]     
            %   'ub_hyp_dchol'                  [10]          
            %   'lb_hyp_sigma2'                 [-8]    
            %   'ub_hyp_sigma2'                 [Auto calibrate with training dataset]
            %   'reinterpolation'               [false], true
            %   'tau_type'                      ['cholesk'], 'isotropic', 'heteroskedastic'
            %   'marginal_likelihood'           ['Marginal_likelihood']
            %   'optim_method'                  ['active-set'], 'interior-point', 'sqp', 'cmaes'
            
            % Parser
            p = inputParser;
            p.KeepUnmatched = true;
            p.PartialMatching = false;
            
            hyp_scalar = @(x) isnumeric(x) && ( isempty(x)||isscalar(x) );
            hyp_row = @(x) isnumeric(x) && ( isempty(x)||isrow(x) );
            
            % Char
            p.addOptional('marginal_likelihood','Marginal_likelihood',@(x)isa(x,'char'));
            % Positive Integer
            p.addOptional('reg_max_level_interactions',2,@(x)(isscalar(x)&&isinteger(x)&&x>=0));
            % Multiple choice char
            p.addOptional('regpoly','regpoly0',@(x)(isa(x,'char'))&&(strcmpi(x,'regpoly0')||strcmpi(x,'regpoly1')||strcmpi(x,'regpoly2')||strcmpi(x,'')));
            p.addOptional('corr','Q_Matern5_2',@(x)(isa(x,'char'))&&(strcmpi(x,'Q_Matern5_2')||strcmpi(x,'Q_Matern3_2')||strcmpi(x,'Q_Gauss')));
            p.addOptional('tau_type','choleski',@(x)(isa(x,'char'))&&(strcmpi(x,'isotropic')||strcmpi(x,'heteroskedastic')));
            p.addOptional('optim_method','active-set',@(x)(isa(x,'char'))&&(strcmpi(x,'interior-point')||strcmpi(x,'sqp')||strcmpi(x,'cmaes')));
            % Boolean
            p.addOptional('reg'             ,false,@(x)islogical(x));
            p.addOptional('var_opti'        ,false,@(x)islogical(x));
            p.addOptional('reinterpolation' ,false,@(x)islogical(x));
            % Scalar
            p.addOptional('hyp_reg'         ,[],hyp_scalar);
            p.addOptional('lb_hyp_reg'      ,[],hyp_scalar);
            p.addOptional('ub_hyp_reg'      ,[],hyp_scalar);
            p.addOptional('hyp_reg_0'       ,[],hyp_scalar);
            p.addOptional('hyp_sigma2'      ,[],hyp_scalar);
            p.addOptional('lb_hyp_sigma2'   ,[],hyp_scalar);
            p.addOptional('ub_hyp_sigma2'   ,[],hyp_scalar);
            p.addOptional('hyp_sigma2_0'    ,[],hyp_scalar);
            % Row
            p.addOptional('hyp_corr'        ,[],hyp_row);
            p.addOptional('hyp_tau'         ,[],hyp_row);
            p.addOptional('hyp_dchol'       ,[],hyp_row);
            p.addOptional('lb_hyp_corr'     ,[],hyp_row);
            p.addOptional('ub_hyp_corr'     ,[],hyp_row);
            p.addOptional('lb_hyp_tau'      ,[],hyp_row);
            p.addOptional('ub_hyp_tau'      ,[],hyp_row);
            p.addOptional('lb_hyp_dchol'    ,[],hyp_row);
            p.addOptional('ub_hyp_dchol'    ,[],hyp_row);
            p.addOptional('hyp_corr_0'      ,[],hyp_row);
            p.addOptional('hyp_tau_0'       ,[],hyp_row);
            p.addOptional('hyp_dchol_0'     ,[],hyp_row);
            
            p.parse(varargin{:})
            in = p.Results;
            unmatched = p.Unmatched;
            
            % Superclass constructor
            obj@Metamodel(prob,y_ind,g_ind,unmatched)
                        
            % Store
            obj.regpoly = in.regpoly;
            obj.reg_max_level_interactions = in.reg_max_level_interactions;
            obj.corr = str2func( in.corr );
            obj.reg = in.reg;
            obj.var_opti = in.var_opti;
            obj.hyp_corr = in.hyp_corr;
            obj.hyp_reg = in.hyp_reg;
            obj.hyp_tau = in.hyp_tau;
            obj.hyp_dchol = in.hyp_dchol;
            obj.hyp_sigma2 = in.hyp_sigma2;
            obj.hyp_corr_0 = in.hyp_corr_0;
            obj.hyp_reg_0 = in.hyp_reg_0;
            obj.hyp_tau_0 = in.hyp_tau_0;
            obj.hyp_dchol_0 = in.hyp_dchol_0;
            obj.hyp_sigma2_0 = in.hyp_sigma2_0;
            obj.lb_hyp_corr = in.lb_hyp_corr;
            obj.ub_hyp_corr = in.ub_hyp_corr;
            obj.lb_hyp_reg = in.lb_hyp_reg;
            obj.ub_hyp_reg = in.ub_hyp_reg;
            obj.lb_hyp_tau = in.lb_hyp_tau;
            obj.ub_hyp_tau = in.ub_hyp_tau;
            obj.lb_hyp_dchol = in.lb_hyp_dchol;
            obj.ub_hyp_dchol = in.ub_hyp_dchol;
            obj.lb_hyp_sigma2 = in.lb_hyp_sigma2;
            obj.ub_hyp_sigma2 = in.ub_hyp_sigma2;
            obj.reinterpolation = in.reinterpolation;
            obj.tau_type = in.tau_type;
            obj.marginal_likelihood = str2func( in.marginal_likelihood );
            obj.optim_method = in.optim_method;
            
            % Training
            obj = obj.Train();  
            
        end
        
        obj = Train( obj );
        
%         varargout = Predict( obj, x_eval);
        
        Tau = Init_tau_id( obj );
        
        obj = Set_optim( obj, hyp_reg, hyp_sigma2, hyp_corr, hyp_tau, hyp_dchol );
        
        obj = Fit( obj, samples, values );
        
        obj = Set_data( obj, samples, values );
        
        [degrees, usedIdx] = Generate_degrees( obj, dj );
        
        [F, dF] = Regression_matrix( obj, points );
        
        [obj, optimHp, perf] = Tune_parameters( obj, F );
        
        [obj, err] = Update_sto ( obj, hp );
        
        p_tau = Preproc_tau ( obj, dist_idx_psi, m_t, n_x, tau_sph, q1, q2, tau_type, hyp_dchol );
        
        Tau = Tau_wrap( obj, Tau_0, m_t, type, D_chol);
        
        psi = Ext_corr ( obj, points1,  q1, points2, q2 )
        
        Sigma = Int_cov ( obj );
        
        [obj, err] = Update_reg( obj, F, hp ); %Comments to be added
        
        out = Marginal_likelihood( obj ); %Comments to be added
        
        obj = Update_model( obj, F, hp ); %Comments to be added
        
        Tau = Build_tau( obj, HS_Coord, m, type, D_chol )
        
    end
    
end

