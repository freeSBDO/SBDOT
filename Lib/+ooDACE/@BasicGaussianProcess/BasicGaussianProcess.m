%> @file "@BasicGaussianProcess/BasicGaussianProcess.m"
%> @authors Ivo Couckuyt
%> @version 1.4 ($Revision$)
%> @date $LastChangedDate$
%> @date Copyright 2010-2013
%>
%> This file is part of the ooDACE toolbox
%> and you can redistribute it and/or modify it under the terms of the
%> GNU Affero General Public License version 3 as published by the
%> Free Software Foundation.  With the additional provision that a commercial
%> license must be purchased if the ooDACE toolbox is used, modified, or extended
%> in a commercial setting. For details see the included LICENSE.txt file.
%> When referring to the ooDACE toolbox please make reference to the corresponding
%> publications:
%>   - Blind Kriging: Implementation and performance analysis
%>     I. Couckuyt, A. Forrester, D. Gorissen, F. De Turck, T. Dhaene,
%>     Advances in Engineering Software,
%>     Vol. 49, pp. 1-13, July 2012.
%>   - Surrogate-based infill optimization applied to electromagnetic problems
%>     I. Couckuyt, F. Declercq, T. Dhaene, H. Rogier, L. Knockaert,
%>     International Journal of RF and Microwave Computer-Aided Engineering (RFMiCAE),
%>     Special Issue on Advances in Design Optimization of Microwave/RF Circuits and Systems,
%>     Vol. 20, No. 5, pp. 492-501, September 2010. 
%>
%> Contact : ivo.couckuyt@ugent.be - http://sumo.intec.ugent.be/?q=ooDACE
%> Signature
%>	BasicGaussianProcess
%
% ======================================================================
%> @brief A kriging surrogate model (also known as a Gaussian Process)
%>
%> Papers:
%> - "Design and Analysis of Computer Experiments",
%>   J. Sacks, W. Welch, T. Mitchell, H. Wynn,
%>   1989
%> - "Design and Analysis of Simulation Experiments",
%>   J.P.C. Kleijnen,
%>   Springer, 2008
%> - "Engineering Design Via Surrogate Modelling: A Practical Guide",
%>   A. Forrester and A. Sobester and A. Keane,
%>   Wiley, 2008
%> - "Gaussian Processes for Machine Learning",
%>   C. E. Rasmussen and C. K. I. Williams,
%>   MIT Press, 2006
%>
%> @todo Refactor correlation functions into proper basis function class
%> hierarchy.
%> @todo solve the correlation matrix vs covariance matrix issue
% ======================================================================
classdef BasicGaussianProcess

    % constants
    properties (Constant = true)
        RHO = 1; %>< index of the rho parameter
        LAMBDA = 2; %>< index of the lambda parameter
        SIGMA2 = 3; %>< index of the sigma2 parameter
        HP = 4; %>< index of the correlation function parameters
    end

    properties (Access = private)
        % dataset
        samples = []; %>< input sample matrix
		values = []; %>< output value matrix
        
        % NOTE: it is inevitable to have protected properties. But try to keep many private, as much as possible.
        %% L1 parameters
        rank = []; %>< rank of correlation matrix
        P = []; %>< permutation vector
    end
    
	properties (Access = protected)
		%% static part (=ModelFactory options)
		options = [];
		
		%% L2 parameters
		regressionFcn = 'regpoly0'; %>< degrees matrix (strings are converted)
		correlationFcn = @corrgauss; %>< string -> function handle
		
		%> @brief initial hp values OR the real ones (if optimization is done
		%> outside the class)
		hyperparameters0 = [];

        % preprocessing values
		dist = []; %>< sample inter-distance
		distIdxPsi = []; %>< indexing needed to calculate psi from D
        
        optimIdx = []; %>< logical indices to parameters that are optimized
        optimNrParameters = []; %>< number of optimization parameter (vector; one entry per type of parameter)
		
		%% L1 parameters
		alpha = []; %>< Regression coefficients
		gamma = []; %>< 'Correlation part' coefficients
		
        hyperparameters = []; %>< correlation parameters
        rho = 1;
        
        C = []; %>< Choleski Decomposition of extrinsic + intrinsic matrices
        
        % extrinsic (uncertainty of the random field of kriging = where we have no data)
        %psi; % NOT kept explicitly
        sigma2 = []; %>< process variance of the GP (extrinsic variance )
        
        % intrinsic (uncertainty of response surface = inherent to stochastic simulation)
		tau2 = []; %>< intrinsic variance
        Sigma = []; %>< intrinsic covariance matrix (amount of regression of stochastic part)
        
        %% only used for prediction variance!
		Ft = []; %>< decorrelated model matrix
		R = []; %>< from QR decomposition of regression part
        
        % keep reinterpolation versions if needed
        %> @note reinterpolation: might be nicer to just construct and keep a sub-GP... takes more space, some calculations are done twice but performance shouldn't take a very big hit...
        sigma2_reinterp = []; %>< Reinterpolation version of @c sigma2
        C_reinterp = []; %>< Reinterpolation version of @c C
        Ft_reinterp = []; %>< Reinterpolation version of @c Ft
        R_reinterp = []; %>< Reinterpolation version of @c R
		
	end

	% PUBLIC
	methods( Access = public )

		% ======================================================================
        %> @brief Class constructor
        %>
        %> @param options Options structure
        %> @param hyperparameters0 Initial theta values
        %> @param regressionFcn The type of trend function to use ('regpoly0', 'regpoly1', ...)
        %> @param correlationFcn Function handle to the correlation function (\@corrgauss, ...)
        %>
        %> @return instance of the basicGaussianProcess class.
        % ======================================================================
		function this = BasicGaussianProcess(varargin)

			% default CTor
			if(nargin == 0)
				%use defaults
			% copy CTor
			elseif isa(varargin{1}, 'BasicGaussianProcess')
				this = varargin{1};
			else
				if nargin == 2
					this.options = varargin{1};
					this.hyperparameters0 = varargin{2};
				elseif nargin == 3
					this.options = varargin{1};
					this.hyperparameters0 = varargin{2};
					this.regressionFcn = varargin{3};
				elseif nargin == 4
					this.options = varargin{1};
					this.hyperparameters0 = varargin{2};
					this.regressionFcn = varargin{3};
					this.correlationFcn = varargin{4};
				else
					error('Invalid number of parameters given');
                end			
                
				% modif_cdu, commented :
                % convert strings to function handles
                % Sanitize bounds and theta0
                
			end % end outer if
            
            % initialize indices to the optimization parameters
            % modif_cdu, ones( 1, 4 ) => true( 1, 4 ) :
            this.optimIdx = true( 1, 4 );
            
            % disable the optimization parameters
            if isinf( this.options.rho0 )
                this.optimIdx(this.RHO) = false;
            end
            if isinf( this.options.lambda0 )
                this.optimIdx(this.LAMBDA) = false;
            end
            if isnan( this.options.sigma20 )
                this.optimIdx(this.SIGMA2) = false;
            end
            
            
            % apparantly a conversion is needed...
            % modif_cdu, commented :
            %this.optimIdx = logical(this.optimIdx);
            this.optimNrParameters = ones(1,sum(this.optimIdx,2));
            this.optimNrParameters(end) = size( this.hyperparameters0, 2 );
			
             % warn the user early if something is not possible
            if this.options.reinterpolation && ~this.optimIdx(1,this.LAMBDA)
               error('Reinterpolation of the kriging error only makes sense for regression kriging.'); 
            end
            
            if length(this.options.lambda0) > 1 && ~this.optimIdx(1,this.SIGMA2)
                error('Stochastic kriging only possible by including sigma2 in the hyperparameter optimization.');
            end
            
            if this.options.reinterpolation && this.optimIdx(1,this.SIGMA2)
                error('Reinterpolation of the predicted variance not possible when sigma2 is included in the hyperparameter optimization (stochastic kriging).');
            end
		end % constructor

		%% Function definitions (mostly getters)
		
        % ======================================================================
        %> @brief Returns the hyperparameters
        % ======================================================================
		function hp = getHyperparameters(this)
			hp = cell2mat(this.hyperparameters);
		end
		
        % ======================================================================
        %> @brief Returns the rho parameter (only valid for @c CoKriging)
        % ======================================================================
		function rho = getRho(this)
			rho = this.rho;
		end
		
        % ======================================================================
        %> @brief Returns the process variance (sigma2)
        % ======================================================================
		function sigma2 = getProcessVariance(this)
			sigma2 = this.sigma2;
		end
        
        % ======================================================================
        %> @brief Returns the full extrinsic correlation matrix
        % ======================================================================
        function corr = getCorrelationMatrix(this)
            corr = this.C*this.C';
        end
        
        % ======================================================================
        %> @brief Returns the intrinsic covariance matrix
        % ======================================================================
		function Sigma = getSigma(this)
			Sigma = this.Sigma;
        end
        
        % ======================================================================
        %> @brief Returns the model matrix (Vandermonde matrix)
        % ======================================================================
        function F = getRegressionMatrix(this)
            F = this.C * this.Ft;
        end
	
        % ======================================================================
        %> @brief Returns the input sample matrix
        % ======================================================================
        function samples = getSamples(this)
          samples = this.samples(this.P,:);
        end
        
        % ======================================================================
        %> @brief Returns the output value matrix
        % ======================================================================
        function values = getValues(this)
          values = this.values(this.P,:);
        end
        
        % ======================================================================
        %> @brief Sets a value in the options structure
        %>
        %> @param key option name
        %> @param value option value
        % ======================================================================
        function this = setOption(this, key, value)
            this.options.(key) = value;
        end

        % ======================================================================
        %> @brief Clears some unused variables.
        % ======================================================================
        function this = cleanup(this)
            % hack: not needed anymore, free it for more memory ;-)
            this.dist = [];
            this.distIdxPsi = [];
        end
        
        % ======================================================================
        %> @brief Returns user-friendly description of the class instance
        % ======================================================================
        function desc = display(this)
            correlationFunc = this.correlationFunction();
            hp = sprintf('%.02f ', this.getHyperparameters() );
            lambda = sprintf('%.03e ', full( mean(diag(this.getSigma())) ) );
            
            desc = sprintf('Kriging model with correlation function %s ( %s)\nAverage Sigma %s\n', ...
            correlationFunc, hp, lambda );
        
            disp(' ');
            disp([inputname(1),' = '])
            disp(' ');
            disp(desc);
        end
        
 		%% Function declarations

        % ======================================================================
        %> @brief Fits a gaussian process for a dataset
        %>
        %> @param samples input sample matrix
        %> @param values output value matrix
        % ======================================================================
		this = fit(this, samples, values);

        % ======================================================================
        %> @brief Predict the mean and/or variance for one or more points x
        %>
        %> @param points Matrix of input points to be predicted
        %> @retval values predicted output values
        %> @retval sigma2 predicted variance of the output values (optional)
        % ======================================================================
		[values, sigma2] = predict(this, points);

		% ======================================================================
        %> @brief Predict the derivatives of the mean and/or variance for a points 
        %>
        %> @param point input point to calculate the derivative of
        %> @retval dvalues Derivative w.r.t. the output
        %> @retval sigma2 Derivative w.r.t. the output variance (optional)
        % ======================================================================
		[dvalues, dsigma2] = predict_derivatives(this, point);
        
        % ======================================================================
        %> @brief Limit predictor of kriging (EXPERIMENTAL)
        %>
        %> @param points Matrix of input points to be predicted
        %> @retval values predicted output values
        %> @retval sigma2 predicted variance of the output values (optional)
        % ======================================================================
		[values, sigma2] = predict_limit(this, points);

		% ======================================================================
        %> @brief Returns the regression function
        %>
        %> The expression is based on the scaled data
        %>
        %> @param options Options struct
        %> @retval regressionFcn Degree matrix representing the regression function
        %> @retval expression Symbolic expression
        %> @retval terms Cell array of the individual terms
        % ======================================================================
        [regressionFcn, expression, terms] = regressionFunction(this,options);
        
        % ======================================================================
        %> @brief Returns the internal correlation function handle and a symbolic expression of the
        %> the correlation part
        %>
        %> The expression is based on the scaled data
        %>        
        %> @param options Options struct
        %> @retval correlationFcn String of correlation function
        %> @retval expression Symbolic expression
        % ======================================================================
        [correlationFcn, expression] = correlationFunction(this,options);
        
        % ======================================================================
        %> @brief Returns the Matlab expression of this Gaussian Process
        %> model
        %>        
        %> @param options Options struct
        %> @retval expression Symbolic expression
        % ======================================================================
        expression = getExpression(this,options);

		% ======================================================================
        %> @brief Calculates the log of the leave-one-out cross validation error (LOO-CV)
        %>
        %> @retval out log(loo-cv) score
        % ======================================================================
        out = cvpe(this);
        
        % ======================================================================
        %> @brief Marginal likelihood function
        %>
        %> @param dpsi cell array of derivative matrices (optional; for internal use only)
        %> @retval out score
        %> @retval dout Derivatives w.r.t. hyperparameters
        % ======================================================================
		[out, dout] = marginalLikelihood(this, dpsi, dsigma2);
        
        % ======================================================================
        %> @brief Leave-one-out predictive log probability (pseudo-likelihood)
        %>
        %> @param dpsi cell array of derivative matrices (optional; for internal use only)
        %> @retval out score
        %> @retval dout Derivatives w.r.t. hyperparameters
        % ======================================================================
		[out, dout] = pseudoLikelihood(this, dpsi, dsigma2);
        
		% ======================================================================
        %> @brief Calculates error on holdout set
        %>
        %> @param testx input samples of the test set
        %> @param testy output samples of the test set
        %> @retval out mse error on test set
        % ======================================================================
        out = mseTestset(this, testx, testy);
        
        % ======================================================================
        %> @brief Calculates the log of the integrated mean squared error
        %>
        %> @retval out log(imse) score
        % ======================================================================
        out = imse(this);
		        
		% ======================================================================
        %> @brief Quantifies magnification of noise (lower is better)
        %>
        %> @retval rc robustness-criterion
        % ======================================================================
        rc = rcValues(this);
        
        % ======================================================================
        %> @brief Variogram plot (EXPERIMENTAL)
        %>
        %> @retval h Figure handle
        % ======================================================================
        h = plotVariogram(this);
	end % methods public
    
    %% PROTECTED (needed by @KrigingModel of SUMO toolbox)
    methods( Access = protected )
        
        % Overrided by kriging extensions and variants. (e.g., cokriging)
        
        % ======================================================================
        %> @brief Sets samples and values matrix
        %>
        %> @param samples input sample matrix
        %> @param values output value matrix
        % ======================================================================
        function this = setData(this, samples, values)
          assert( size(this.samples,1) == size(this.values,1), 'Samples matrix does not match values matrix in size.' );
          
          this.samples = samples;
          this.values = values;
          this.P = 1:size(this.samples,1);
        end
        
        % ======================================================================
        %> @brief Constructs model
        %>
        %> @param F model matrix
        %> @param hp new hyperparameters
        % ======================================================================   
		this = updateModel(this, F, hp);
        
        % ======================================================================
        %> @brief Constructs regression part
        %>
        %> @param F model matrix
        %> @param hp new hyperparameters
        %> @retval err error string (if any)
        % ======================================================================
		[this, err, dsigma2] = updateRegression(this, F, hp );
		
		% ======================================================================
        %> @brief Constructs correlation part
        %>
        %> @param hp hyperparameters
        %> @retval err error string (if any)
        %> @retval dpsi Derivative of correlation matrix w.r.t. the hyperparameters
        % ======================================================================
		[this, err, dpsi] = updateStochasticProcess(this, hp );
					
		% ======================================================================
        %> @brief Constructs extrinsic correlation matrix
        %>
        %> @param points1 input point matrix (optional)
        %> @param points2 input point matrix (optional)
        %> @retval psi Correlation matrix
        %> @retval dpsi Derivative of correlation matrix w.r.t. the hyperparameters
        % ======================================================================
		[psi, dpsi] = extrinsicCorrelationMatrix(this, points1, points2);
        
        % ======================================================================
        %> @brief Constructs intrinsic covariance matrix (stochastic kriging/regression kriging)
        %>
        %> @param points1 input point matrix (optional)
        %> @param points2 input point matrix (optional)
        %> @retval psi Covariance matrix
        %> @retval dpsi Derivative of covariance matrix w.r.t. the hyperparameters OR the input points
        % ======================================================================
		[Sigma, dSigma] = intrinsicCovarianceMatrix(this, points1, points2);
        
        % ======================================================================
        %> @brief Constructs regression matrix
        %>
        %> @param points input point matrix (optional)
        %> @retval F Model matrix
        %> @retval dF Derivative of model matrix w.r.t. the hyperparameters OR the input points
        % ======================================================================    
		[F, dF] = regressionMatrix(this, points);
        
        % ======================================================================
        %> @brief Hyperparameter optimization
        %>
        %> @param F model matrix
        %> @retval optimHp optimized hyperparameters
        %> @retval perf Performance score (likelihood score)
        % ======================================================================    		
		[this, optimHp, perf] = tuneParameters(this, F);
        
        % ======================================================================
        %> @brief Generate degrees matrix from individual ones
        %>
        %> @param dj Cell array of degree matrices (for each dimension)
        %> @retval degrees Full degrees matrix
        %> @retval idx Cell array of indices (used by blind kriging)
        % ======================================================================
		[degrees, idx] = generateDegrees(this, dj);
    end % methods protected

    %% PRIVATE
	methods( Access = private )
		
		% ======================================================================
        %> @brief Likelihood function
        %>
        %> @param F model matrix
        %> @param hp hyperparameters
        %> @retval out score
        %> @retval dout Derivatives w.r.t. hyperparameters
        % ======================================================================
		[out, dout] = likelihood(this, F, hp);
        
		% ======================================================================
        %> @brief Contour plot of the likelihood surface (for 2D; EXPERIMENTAL)
        %>
        %> @param func function handle to the likelihood function
        %> @param param hyperparameters
        %> @param perf performance (likelihood)
        %> @retval h Figure handle
        % ======================================================================
		h = plotLikelihood(this,func,param, perf);
        
        % adjoint derivative utility functions (unused atm)
        [L1adj, T1adj] = reverse_backwardSub( T2adj, L1, T2 );
        Radj = reverse_cholesky( L2, Ladj );
        L2adj = reverse_forwardSub( T1adj, L2, T1 )
        
	end % methods private
    
    methods( Static )

        % ======================================================================
        %> @brief Returns a default options structure
        %>
        %> Available options:
        %> @code
        %> options = struct( ...
        %>     'generateHyperparameters0', false, ...
        %>     'hpBounds', [], ... % hyperparameter bounds
        %>     'hpOptimizer', [], ... % optimizer class
        %>     'hpLikelihood', @marginalLikelihood, ...
        %>     'sigma20', NaN, ... % initial value for sigma2
        %>     'sigma2Bounds', [0.001 ; 10], ... % sigma2 parameter bounds
        %>     'lambda0' ,-Inf, ... % initial lambda values
        %>     'lambdaBounds', [-10 ; 0], ... % lambda parameter bounds (in log scale)
        %>     'Sigma', [], ... % intrinsic covariance matrix (stochastic kriging)
        %>     'reinterpolation', false, ... % reinterpolate error (replaces standard error)
        %>     'lowRankApproximation', false, ... % enable low rank approximation of correlation matrix
        %>     'rankTol', 1e-12, ... % tolerance for lowRankApprox.
        %>     'rankMax', Inf, ... % maximum rank to achieve for lowRankApprox.
        %>     'regressionMaxLevelInteractions', 2, ... % consider maximal two-level interactions
        %>     'debug', false, ... % enables debug plot of the likelihood function
        %>...  % Cokriging specific
        %>     'rho0', -Inf, ... % initial scaling factor between datasets
        %>     'rhoBounds', [1 ; 5] ... % scaling factor bounds
        %>     );
        %> @endcode
        %> @retval options Options structure
        % ======================================================================
        function options = getDefaultOptions()
            options = struct( ...
                'generateHyperparameters0', false, ...
                'hpBounds', [], ... % hyperparameter bounds
                'hpOptimizer', ooDACE.SQPLabOptimizer( 1, 1 ), ... % optimizer class
                'hpLikelihood', @marginalLikelihood, ...
                'sigma20', NaN, ... % initial value for sigma2
                'sigma2Bounds', [-1; 5], ... % sigma2 parameter bounds (in log scale
                'lambda0' ,-Inf, ... % initial lambda values
                'lambdaBounds', [0; 5], ... % lambda parameter bounds (in log scale)
                'Sigma', [], ... % intrinsic covariance matrix (stochastic kriging)
                'reinterpolation', false, ... % reinterpolate error (replaces standard error)
                'lowRankApproximation', false, ... % enable low rank approximation of correlation matrix
                'rankTol', 1e-12, ... % tolerance for lowRankApprox.
                'rankMax', Inf, ... % maximum rank to achieve for lowRankApprox.
                'regressionMaxLevelInteractions', 2, ... % consider maximal two-level interactions
                'debug', false, ... % enables debug plot of the likelihood function
...             % Cokriging specific (disabled)
                'rho0', -Inf, ...
                'rhoBounds', [0.1 ; 5] ...
                );
		end
    end % methods static
end % classdef
