classdef Kriging < Metamodel
    % KRIGING class
    % Gaussian process based metamodel using ooDACE lib
    %
    % obj = Kriging( prob, y_ind, g_ind, varargin)
    %
    % Mandatory inputs :
    %   - prob is a Problem object, created with the appropriate class constructor
    %   - y_ind is the index of the objective to optimize
    %   - g_ind is the index of the constraint(s) to take into account
    %
    % Optional inputs [default value]:
    %   - regpoly is the regression order of Kriging
    %   ['regpoly0'], 'regpoly1', 'regpoly2', 'regpoly3'
    %	- corr if the correlation function to use
    %   ['corrmatern52'], 'correxp', 'corrgauss', 'corrmatern32'
    %	- reg is a boolean to activate regression (if true)
    %   [false]
    %	- hyp_corr is the correlation length parameter (if set, it is not optimized)
    %   []
    %	- hyp_reg is the Kriging regression parameter (if set, it is not optimized)
    %   []
    %	- hyp_corr0 is the initial correlation length for optimization
    %   [Auto calibrate with training dataset]
    %	- lb_hyp_corr is the lower bound of correlation length
    %   [Auto calibrate with training dataset]
    %	- ub_hyp_corr is the upper bound of correlation length
    %   [Auto calibrate with training dataset]
    %	- lb_hyp_reg is the lower bound of regression parameter
    %   [Auto calibrate with training dataset]
    %	- ub_hyp_reg is the upper bound of regression parameter
    %   [Auto calibrate with training dataset]
    %	- estim_hyp          % Method for hyperparameter estimation
    %   [@marginalLikelihood], @pseudoLikelihood
    %	- go_opt is a boolean to activate Global Optimization of hyp, local by default
    %   [false], true 
    %
        
    properties ( Access = public )
        
        % Optional inputs (varargin) 
        regpoly            % Regression order of Kriging
        corr               % Correlation function
        reg                % Boolean to activate regression
        hyp_corr           % Correlation length parameter
        hyp_reg            % Kriging regression parameter
        hyp_corr0          % Initial correlation length for optimization
        lb_hyp_corr        % Lower bound of correlation length
        ub_hyp_corr        % Upper bound of correlation length
        lb_hyp_reg         % Lower bound of regression parameter
        ub_hyp_reg         % Upper bound of regression parameter
        estim_hyp          % Method for hyperparameter estimation
        go_opt             % Boolean to activate Global Optimization of hyp
        
        % Computed variables
        k_oodace      % ooDace Kriging object
        hyp_corr_bounds
        hyp_reg_bounds
        
    end
    
    methods

        function obj=Kriging(prob,y_ind,g_ind,varargin)
            % Kriging constructor (see also Metamodel)
            %
            % Initialized a Kriging object with mandatory inputs :
            % 	obj=Kriging(prob,y_ind,g_ind)
            %
            % Initialized a problem object with optionnal inputs :
            % 	obj=Metamodel(prob,y_ind,g_ind,varargin)
            %   obj=Metamodel(prob,y_ind,g_ind,'regpoly','regpoly0')
            %
            % Optionnal inputs [default value] :
            %   'regpoly'	['regpoly0'], 'regpoly1', 'regpoly2', 'regpoly3'
            %   'corr'      ['corrmatern52'], 'correxp', 'corrgauss', 'corrmatern32'
            %   'reg'       [false]
            %   'hyp_corr'  []       
            %   'hyp_reg'   []   
            %   'hyp_corr0' [Auto calibrate with training dataset]
            %   'lb_hyperp' [Auto calibrate with training dataset]     
            %   'ub_hyperp' [Auto calibrate with training dataset]          
            %   'lb_reg'    [Auto calibrate with training dataset]           
            %   'ub_reg'    [Auto calibrate with training dataset]  
            %   'estim_hyp' [@marginalLikelihood], @pseudoLikelihood
            %   'go_opt'    [false], true
            
            % Parser
            p = inputParser;
            p.KeepUnmatched = true;
            p.PartialMatching = false;
            p.addOptional('regpoly','regpoly0',@(x)(isa(x,'char'))&&(strcmpi(x,'regpoly0')||strcmpi(x,'regpoly1')||strcmpi(x,'regpoly2')||strcmpi(x,'')));
            p.addOptional('corr','corrmatern52',@(x)(isa(x,'char'))&&(strcmpi(x,'correxp')||strcmpi(x,'corrgauss')||strcmpi(x,'corrmatern52')||strcmpi(x,'corrmatern32')));
            p.addOptional('reg',false,@(x)islogical(x));
            p.addOptional('hyp_corr',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.addOptional('hyp_reg',[],@(x)isnumeric(x)&&(isempty(x)||isscalar(x)));
            p.addOptional('hyp_corr0',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.addOptional('lb_hyp_corr',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.addOptional('ub_hyp_corr',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.addOptional('lb_hyp_reg',[],@(x)isnumeric(x)&&(isempty(x)||isscalar(x)));
            p.addOptional('ub_hyp_reg',[],@(x)isnumeric(x)&&(isempty(x)||isscalar(x)));
            p.addOptional('estim_hyp',@marginalLikelihood,@(x)(isequal(x,@marginalLikelihood) || isequal(x,@pseudoLikelihood)));
            p.addOptional('go_opt',false,@(x)islogical(x));
            p.parse(varargin{:})
            in = p.Results;
            unmatched = p.Unmatched;
            
            % Superclass constructor
            obj@Metamodel(prob,y_ind,g_ind,unmatched)
                        
            % Store
            obj.regpoly = in.regpoly;
            obj.corr = str2func( ['ooDACE.basisfunctions.',in.corr] );
            obj.reg = in.reg;
            obj.hyp_corr = in.hyp_corr;            
            obj.hyp_reg = in.hyp_reg;
            obj.hyp_corr0 = in.hyp_corr0;
            obj.lb_hyp_corr = in.lb_hyp_corr;
            obj.ub_hyp_corr = in.ub_hyp_corr;
            obj.lb_hyp_reg = in.lb_hyp_reg;
            obj.ub_hyp_reg = in.ub_hyp_reg;  
            obj.estim_hyp = in.estim_hyp; 
            obj.go_opt = in.go_opt; 
            
            % Training
            obj.Train();  
            
        end
         
        [] = Train( obj );
        varargout = Predict( obj, x_eval);
        [] = Clean( obj , type )
        
    end
    
end

