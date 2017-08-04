classdef Cokriging < Metamodel
    % COKRIGING class
    % Gaussian process based multifidelity metamodel using ooDACE lib
    
    properties ( Access = public )
        
        % Optional inputs (varargin) 
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
            %   'lb_hyperp_*' [Auto calibrate with training dataset]     
            %   'ub_hyperp_*' [Auto calibrate with training dataset]          
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

