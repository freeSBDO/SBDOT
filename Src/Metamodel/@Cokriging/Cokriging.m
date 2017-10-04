classdef Cokriging < Metamodel
    % COKRIGING class
    % Gaussian process based multifidelity metamodel using ooDACE lib
    %
    % obj = Cokriging( prob, y_ind, g_ind, varargin)
    %
    % Mandatory inputs :
    %   - prob is a Problem_multifi object, created with the appropriate class constructor
    %   - y_ind is the index of the objective to optimize
    %   - g_ind is the index of the constraint(s) to take into account
    %
    % Optional inputs [default value], 
    % * has to be replaced by HF or LF depending on the option applies to 
    % high fidelity model or low fidelity model :
    %
    %   - 'regpoly_*' is the regression order of Kriging
    %   ['regpoly0'], 'regpoly1', 'regpoly2', 'regpoly3'
    %	- 'corr_*' if the correlation function to use
    %   ['corrmatern52'], 'correxp', 'corrgauss', 'corrmatern32'
    %	- 'reg_*' is a boolean to activate regression (if true)
    %   [false]
    %	- 'hyp_corr_*' is the correlation length parameter (if set, it is not optimized)
    %   []
    %	- 'hyp_reg_*' is the Kriging regression parameter (if set, it is not optimized)
    %   []
    %   - 'rho' is the scaling factor between models (if set, it is not optimized)        
    %   []
    %	- 'hyp_corr0_*' is the initial correlation length for optimization
    %   [Auto calibrate with training dataset]
    %   - 'rho0' is the scaling factor between models (if set, it is not optimized)        
    %   []
    %	- 'lb_hyp_corr_*' is the lower bound of correlation length
    %   [Auto calibrate with training dataset]
    %	- 'ub_hyp_corr_*' is the upper bound of correlation length
    %   [Auto calibrate with training dataset]
    %	- 'lb_reg_*' is the lower bound of regression parameter
    %   [Auto calibrate with training dataset]
    %	- 'ub_reg_*' is the upper bound of regression parameter
    %   [Auto calibrate with training dataset]
    %   - 'lb_rho'is the lower bound of scaling factor  
    %   [Auto calibrate with training dataset]   
    %   - 'ub_rho'is the upper bound of scaling factor  
    %   [Auto calibrate with training dataset]    
    %	- 'estim_hyp_*' is the method for hyperparameter estimation
    %   [@marginalLikelihood], @pseudoLikelihood
    %	- 'go_opt_*' is a boolean to activate Global Optimization of hyp, local by default
    %   [false], true 
    %
    properties ( Access = public )
        
        % Optional inputs (varargin) 
        % If its a cell, first value corresponds to LF model, second to HF.
        regpoly         % Regression order of Coriging
        corr            % Correlation function
        reg             % Boolean to activate regression
        hyp_corr        % Correlation length parameter
        hyp_reg         % Cokriging regression parameter
        rho             % Scaling parameter between fidelity levels
        hyp_corr0       % Initial correlation length for optimization
        rho0            % Initial scaling parameter for optimization
        lb_hyp_corr     % Lower bound of correlation length
        ub_hyp_corr     % Upper bound of correlation length
        lb_hyp_reg      % Lower bound of regression parameter
        ub_hyp_reg      % Upper bound of regression parameter
        lb_rho          % Lower bound of scaling parameter
        ub_rho          % Upper bound of scaling parameter
        estim_hyp       % Method for hyperparameter estimation
        go_opt          % Boolean to activate Global Optimization of hyp
                
        % Computed variables
        ck_oodace      % ooDace Kriging object
        hyp_corr_bounds
        hyp_reg_bounds
        
    end
    
    methods

        function obj=Cokriging(prob,y_ind,g_ind,varargin)
            % Cokriging constructor (see also Metamodel)
            %
            % Initialized a Cokriging object with mandatory inputs :
            % 	obj=Cokriging(prob,y_ind,g_ind)
            %
            % Initialized a Cokriging object with optionnal inputs :
            % 	obj=Cokriging(prob,y_ind,g_ind,varargin)
            %   obj=Cokriging(prob,y_ind,g_ind,'regpoly','regpoly0')
            %
            % Optionnal inputs [default value], * has to be replaced by HF or LF :
            %   'regpoly_*'	['regpoly0'], 'regpoly1', 'regpoly2', 'regpoly3'
            %   'corr_*'      ['corrmatern52'], 'correxp', 'corrgauss', 'corrmatern32'
            %   'reg_*'       [false]
            %   'hyp_corr_*'  []       
            %   'hyp_reg_*'   []   
            %   'rho'         []
            %   'hyp_corr0_*' [Auto calibrate with training dataset]
            %   'rho0'        [Auto calibrate with training dataset]
            %   'lb_hyp_corr_*' [Auto calibrate with training dataset]     
            %   'lb_hyp_corr_*' [Auto calibrate with training dataset]          
            %   'lb_reg_*'    [Auto calibrate with training dataset]           
            %   'ub_reg_*'    [Auto calibrate with training dataset] 
            %   'lb_rho'      [Auto calibrate with training dataset]           
            %   'ub_rho'      [Auto calibrate with training dataset]
            %   'estim_hyp_*' [@marginalLikelihood], @pseudoLikelihood
            %   'go_opt_*'    [false], true
            
            % Parser
            p = inputParser;
            p.KeepUnmatched = true;
            p.PartialMatching = false;
            p.addOptional('rho0',[],@(x)isnumeric(x)&&(isempty(x)||isscalar(x)));
            p.addOptional('lb_rho',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.addOptional('ub_rho',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));  
            
            p.addOptional('regpoly_LF','regpoly0',@(x)(isa(x,'char'))&&(strcmpi(x,'regpoly0')||strcmpi(x,'regpoly1')||strcmpi(x,'regpoly2')||strcmpi(x,'')));
            p.addOptional('corr_LF','corrmatern52',@(x)(isa(x,'char'))&&(strcmpi(x,'correxp')||strcmpi(x,'corrgauss')||strcmpi(x,'corrmatern52')||strcmpi(x,'corrmatern32')));
            p.addOptional('reg_LF',false,@(x)islogical(x));
            p.addOptional('hyp_corr_LF',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.addOptional('hyp_reg_LF',[],@(x)isnumeric(x)&&(isempty(x)||isscalar(x)));
            p.addOptional('hyp_corr0_LF',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.addOptional('lb_hyp_corr_LF',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.addOptional('ub_hyp_corr_LF',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.addOptional('lb_hyp_reg_LF',[],@(x)isnumeric(x)&&(isempty(x)||isscalar(x)));
            p.addOptional('ub_hyp_reg_LF',[],@(x)isnumeric(x)&&(isempty(x)||isscalar(x)));
            p.addOptional('estim_hyp_LF',@marginalLikelihood,@(x)(isequal(x,@marginalLikelihood) || isequal(x,@pseudoLikelihood)));
            p.addOptional('go_opt_LF',false,@(x)islogical(x));
            
            p.addOptional('regpoly_HF','regpoly0',@(x)(isa(x,'char'))&&(strcmpi(x,'regpoly0')||strcmpi(x,'regpoly1')||strcmpi(x,'regpoly2')||strcmpi(x,'')));
            p.addOptional('corr_HF','corrmatern52',@(x)(isa(x,'char'))&&(strcmpi(x,'correxp')||strcmpi(x,'corrgauss')||strcmpi(x,'corrmatern52')||strcmpi(x,'corrmatern32')));
            p.addOptional('reg_HF',false,@(x)islogical(x));
            p.addOptional('hyp_corr_HF',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.addOptional('hyp_reg_HF',[],@(x)isnumeric(x)&&(isempty(x)||isscalar(x)));
            p.addOptional('hyp_corr0_HF',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.addOptional('lb_hyp_corr_HF',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.addOptional('ub_hyp_corr_HF',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.addOptional('lb_hyp_reg_HF',[],@(x)isnumeric(x)&&(isempty(x)||isscalar(x)));
            p.addOptional('ub_hyp_reg_HF',[],@(x)isnumeric(x)&&(isempty(x)||isscalar(x)));
            p.addOptional('estim_hyp_HF',@marginalLikelihood,@(x)(isequal(x,@marginalLikelihood) || isequal(x,@pseudoLikelihood)));
            p.addOptional('go_opt_HF',false,@(x)islogical(x));
            p.parse(varargin{:})
            in = p.Results;
            unmatched = p.Unmatched;
            
            % Superclass constructor
            obj@Metamodel(prob,y_ind,g_ind,unmatched)
                        
            % Store
            obj.regpoly = {in.regpoly_LF , in.regpoly_HF};
            obj.corr = {str2func( ['ooDACE.basisfunctions.',in.corr_LF] ) , ...
                str2func( ['ooDACE.basisfunctions.',in.corr_HF] )};
            obj.reg = {in.reg_LF , in.reg_HF};
            obj.hyp_corr = {in.hyp_corr_LF , in.hyp_corr_HF};            
            obj.hyp_reg = {in.hyp_reg_LF , in.hyp_reg_HF};
            obj.hyp_corr0 = {in.hyp_corr0_LF , in.hyp_corr0_HF};
            obj.lb_hyp_corr = {in.lb_hyp_corr_LF , in.lb_hyp_corr_HF};
            obj.ub_hyp_corr = {in.ub_hyp_corr_LF , in.ub_hyp_corr_HF};
            obj.lb_hyp_reg = {in.lb_hyp_reg_LF , in.lb_hyp_reg_HF};
            obj.ub_hyp_reg = {in.ub_hyp_reg_LF , in.ub_hyp_reg_HF};  
            obj.estim_hyp = {in.estim_hyp_LF , in.estim_hyp_HF}; 
            obj.go_opt = {in.go_opt_LF , in.go_opt_HF}; 
                        
            % Training
            obj.Train();  
            
        end
         
        [] = Train( obj );
        
        [ mean, variance, grad_mean, grad_variance ] = Predict( obj, x_eval);
        
        opts = Def_hyp_corr( obj , type, opts );
        
        [] = Clean( obj , type );
        
    end
    
end

