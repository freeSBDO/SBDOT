%> @file "@Kriging/Kriging.m"
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
%>	Kriging
%
% ======================================================================
%> @brief A kriging surrogate model
%>
%> Is basically the same as the base class BasicGaussianProcess
%> besides the scaling of the samples/values
%>
%> This class is derived by KrigingModel, a class in the SUMO-Toolbox that works like an interface between
%> SUMO and the actual kriging implementation
% ======================================================================
classdef Kriging < ooDACE.BasicGaussianProcess

	properties (Access = private)		
        % preprocessing values
        inputScaling = []; %>< input scaling
		outputScaling = []; %>< output scaling
        
        samples = []; %>< unscaled samples
        values = []; %>< unscaled samples
	end

	% PUBLIC
	methods( Access = public )

		% ======================================================================
        %> @brief Class constructor
        %>
        %> Initializes the kriging model. Takes the same parameters as @c BasicGaussianProcess
        %>
        %> @return instance of the kriging class
        % ======================================================================
		function this = Kriging(varargin)
            this = this@ooDACE.BasicGaussianProcess(varargin{:});
		end % constructor
		
		% ======================================================================
        %> @brief Returns the process variance
        %>
        %> @retval sigma2 process variance
        % ======================================================================
		function sigma2 = getProcessVariance(this)
			sigma2 = this.outputScaling(2,:).^2.*this.sigma2;
        end
        
        % ======================================================================
        %> @brief Returns the input sample matrix
        %> @retval samples unscaled samples (original)
        %> @retval scaledSamples scaled samples
        % ======================================================================
        function [samples, scaledSamples] = getSamples(this)
            samples = this.samples;
            
            if nargout > 1
                scaledSamples = this.getSamples@BasicGaussianProcess();
            end
        end
        
        % ======================================================================
        %> @brief Returns the output value matrix
        %> @retval values unscaled values (original)
        %> @retval scaledValues scaled values
        % ======================================================================
        function [values, scaledValues] = getValues(this)
            values = this.values;
          
            if nargout > 1   
                scaledValues = this.getValues@BasicGaussianProcess();
            end
        end
        
 		%% Function declarations

		% ======================================================================
        %> @brief Predict the mean and/or variance for one or more points x
        %>
        %> @param points Matrix of input points to be predicted
        %> @retval values predicted output values
        %> @retval sigma2 predicted variance of the output values (optional)
        % ======================================================================
		[values, sigma2] = predict(this, points);

		% ======================================================================
        %> @brief Predict the derivatives of the mean and/or variance for a points x
        %>
        %> @param point input point to calculate the derivative of
        %> @retval dvalues Derivative w.r.t. the output
        %> @retval sigma2 Derivative w.r.t. the output variance (optional)
        % ======================================================================
		[dvalues, dsigma2] = predict_derivatives(this, point);

        % ======================================================================
        %> @brief Returns the Matlab expression of this Gaussian Process
        %> model
        %>        
        %> @param options Options struct
        %> @retval expression Symbolic expression
        % ======================================================================
        expression = getExpression(this, outputIndex);
        
		% ======================================================================
        %> @brief Calculates cross validated prediction error (cvpe)
        %>
        %> @retval out cvpe score
        % ======================================================================
		out = cvpe(this);

	end % methods public
    
    %% PROTECTED
    methods( Access = protected )
        
        % ======================================================================
        %> @brief Sets samples and values matrix
        %>
        %> @param samples input sample matrix
        %> @param values output value matrix
        % ======================================================================
        this = setData(this, samples, values);

    end % methods protected

    %% PRIVATE
	methods( Access = private )
	end % methods private
	
	methods( Static )

        % ======================================================================
        %> @brief Returns a default options structure
        %>
        %> @retval options Options structure
        %> @todo Apparantly Matlab 2008b doesn't auto forward the (static) call to BasicGaussianProcess::getDefaultOptions()
        % ======================================================================
        function options = getDefaultOptions()
			options = ooDACE.BasicGaussianProcess.getDefaultOptions();
		end
    end % methods static
end % classdef
