classdef RBF < Metamodel
    % RBF Classe
    % Radial Basis Function metamodel
    
    properties
        
        % Optional inputs (varargin) 
        corr        % Correlation function of RBF
        hyp_corr    % Correlation length paramete
        lb_hyp_corr % Lower bound of correlation length
        ub_hyp_corr % Upper bound of correlation length
        estimator   % Method for estimating parameters
        
        % Computed variables
        hyp_corr0         % Initial hyp_corr value before optimization 
        hyp_corr_bounds   % hyp_coor bounds for optimization
        alpha             % Regression parameter 
        beta              % RBF coefficient estimated
        f_mat             % Regression matrix
        corr_mat          % Correlation matrix
        diff_man          % Matrix of manhattan distance between points
        diff              % Matrix of square difference bewteen points        
        
    end
    
    methods
        
        function obj=RBF(prob,y_ind,g_ind,varargin)
            % RBF constructor (see also Metamodel)
            %
            % Initialized a RBF object with mandatory inputs :
            % 	obj=RBF(prob,y_ind,g_ind)
            %
            % Initialized a RBF object with optionnal inputs :
            % 	obj=RBF(prob,y_ind,g_ind,varargin)
            %   obj=RBF(prob,y_ind,g_ind,'estimator','LOO')
            %
            % Optionnal inputs [default value] :
            %   'corr'        ['corrmatern52'], 'corrgauss', 'corrlinear' , 'corrthinplatespline' , 'corrmultiquadric' , 'corrcubic'
            %   'estimator'   ['LOO'] , 'MLE'  
            %   'hyp_corr'    []       
            %   'lb_hyp_corr' [Auto calibrate with training dataset]     
            %   'ub_hyp_corr' [Auto calibrate with training dataset]          
            
            % Parser
            p = inputParser;
            p.KeepUnmatched = true;
            p.PartialMatching = false;
            p.addOptional('corr','corrmatern52',@(x)(isa(x,'char'))&&(strcmpi(x,'corrgauss')||strcmpi(x,'corrmatern52')||strcmpi(x,'corrlinear')||strcmpi(x,'corrthinplatespline')||strcmpi(x,'corrmultiquadric')||strcmpi(x,'corrcubic')));
            p.addOptional('estimator','LOO',@(x)(isa(x,'char'))&&(strcmpi(x,'LOO')||strcmpi(x,'MLE')));
            p.addOptional('hyp_corr',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.addOptional('lb_hyp_corr',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.addOptional('ub_hyp_corr',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.parse(varargin{:})
            in = p.Results;
            unmatched = p.Unmatched;
            
            % Superclass constructor
            obj@Metamodel(prob,y_ind,g_ind,unmatched)
                        
            % Store
            obj.corr = in.corr;
            obj.estimator = in.estimator; 
            obj.hyp_corr = in.hyp_corr;            
            obj.lb_hyp_corr = in.lb_hyp_corr;
            obj.ub_hyp_corr = in.ub_hyp_corr;                     
            
            % Training
            obj.Train();  
            
        end
        
    end
    
    
end

