classdef RBF < Metamodel
    % RBF Class
    % Radial Basis Function metamodel
    %
    % obj = RBF( prob, y_ind, g_ind, varargin)
    %
    % Mandatory inputs :
    %   - prob is a Problem object, created with the appropriate class constructor
    %   - y_ind is the index of the objective to optimize
    %   - g_ind is the index of the constraint(s) to take into account
    %
    % Optional inputs [default value]:
    %	- corr is the correlation function to use
    %   ['Corrmatern52'], 'Corrgauss', 'Corrlinear' , 'Corrthinplatespline' , 'Corrmultiquadric' , 'Corrcubic', 'Corrinvmultiquadric', 'Corrmatern32'
    %	- hyp_corr is the correlation length parameter (if set, it is not optimized)
    %   []
    %	- lb_hyp_corr is the lower bound of correlation length
    %   [Auto calibrate with training dataset]
    %	- ub_hyp_corr is the upper bound of correlation length
    %   [Auto calibrate with training dataset]
    %	- estimator is the method for hyperparameter estimation
    %   ['LOO'] , 'CV'
    %	- optimizer is the optimizer algorithm to select
    %   ['CMAES'] , 'fmincon'
    %
    
    properties
        
        % Optional inputs (varargin) 
        corr        % Correlation function of RBF
        hyp_corr    % Correlation length paramete (log scale)
        lb_hyp_corr % Lower bound of correlation length
        ub_hyp_corr % Upper bound of correlation length
        estimator   % Method for estimating parameters
        optimizer   % Optimization method for hyperparameters
        
        % Computed variables
        hyp_corr0         % Initial hyp_corr value before optimization 
        hyp_corr_bounds   % hyp_coor bounds for optimization
        alpha             % Regression parameter 
        beta              % RBF coefficient estimated
        f_mat             % Regression matrix
        corr_mat          % Correlation matrix
        zero_mat          % Zero matrix 
        diff_squared      % Matrix of squared manhattan distance between points
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
            %   'corr'        ['Corrmatern52'], 'Corrgauss', 'Corrlinear' , 'Corrthinplatespline' , 'Corrmultiquadric' , 'Corrcubic', 'Corrinvmultiquadric', 'Corrmatern32'
            %   'estimator'   ['LOO'] , 'CV'  
            %   'hyp_corr'    []
            %   'optimizer'   ['CMAES'] , 'fmincon'
            %   'lb_hyp_corr' [Auto calibrate with training dataset]     
            %   'ub_hyp_corr' [Auto calibrate with training dataset]          
            
            % Parser
            p = inputParser;
            p.KeepUnmatched = true;
            p.CaseSensitive = true;
            p.PartialMatching = false;
            p.addOptional('corr','Corrmatern52',@(x)(isa(x,'char'))&&(strcmp(x,'Corrgauss')||strcmp(x,'Corrmatern32')||strcmp(x,'Corrmatern52')||strcmp(x,'Corrlinear')||strcmp(x,'Corrthinplatespline')||strcmp(x,'Corrinvmultiquadric')||strcmp(x,'Corrmultiquadric')||strcmp(x,'Corrcubic')));
            p.addOptional('estimator','LOO',@(x)(isa(x,'char'))&&(strcmp(x,'LOO')||strcmp(x,'CV')));
            p.addOptional('hyp_corr',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.addOptional('lb_hyp_corr',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.addOptional('ub_hyp_corr',[],@(x)isnumeric(x)&&(isempty(x)||isrow(x)));
            p.addOptional('optimizer','CMAES',@(x)(isa(x,'char'))&&(strcmp(x,'CMAES')||strcmp(x,'fmincon')));
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
            obj.optimizer = in.optimizer; 
            
            % Training
            obj.Train();  
            
        end
        
        [] = Train( obj );
        [y_pred, power] = Predict( obj, x_eval );
        [] = Clean( obj , type )
        
        LOO = Loo_error( obj, theta )
        dist_theta = Norm_theta( obj, diff_mat, theta);
        
        [corr_mat, f_mat, zero_mat] = Corrlinear( obj, diff_mat, theta);
        [corr_mat, f_mat, zero_mat] = Corrcubic( obj, diff_mat, theta);
        [corr_mat, f_mat, zero_mat] = Corrthinplatespline( obj, diff_mat, theta);
        [corr_mat, f_mat, zero_mat] = Corrmultiquadric( obj, diff_mat, theta);
        [corr_mat, f_mat, zero_mat] = Corrinvmultiquadric( obj, diff_mat, theta);
        [corr_mat, f_mat, zero_mat] = Corrgauss( obj, diff_mat, theta);
        [corr_mat, f_mat, zero_mat] = Corrmatern32( obj, diff_mat, theta);
        [corr_mat, f_mat, zero_mat] = Corrmatern52( obj, diff_mat, theta);
        
        
    end
    
    
end

