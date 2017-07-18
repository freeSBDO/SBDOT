%> @file "@Optimizer/Optimizer.m"
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
%>	Optimizer
%
% ======================================================================
%> @brief Abstract base class for an optimizer.
%>
%> Optimization methods are to be derived from this class.
%> It provides a logger object for the derived classes
%> and instantiates all constraints
% ======================================================================
classdef Optimizer

	% private members
	properties (SetAccess = 'private', GetAccess = 'private')
		LB;
		UB;
		nvars;
		nobjectives;
		initialPopulation;
		logger;
		hints;
		state;
	end
   
	% public methods
	methods
        % ======================================================================
        %> @brief Creates an Optimizer object, not to be called directly.
        %>
        %> The constructor of the derived class should be called.
        %>
        %> @param nvars Number of dimensions
        %> @param nobjectives Number of cost functions
        %> @return instance of the Optimizer class
        % ======================================================================
		function this = Optimizer(varargin)   
			% get logger
			import java.util.logging.*
			this.logger = Logger.getLogger('Matlab.Optimizer');

			if nargin == 1
				config = varargin{1};
				this.nvars = config.input.getInputDimension();
				this.nobjectives = config.output.getOutputDimension();
			elseif nargin >= 2
				this.nvars = varargin{1};
				this.nobjectives = varargin{2};
				% rest of parameters is for inherited classes
			else
				error('Invalid number of parameters given');
			end

			% set bounds to the default SUMO working range [-1,1], this can be set for a specific task with setBounds()
			this.LB = -ones( 1, this.nvars );
			this.UB =  ones( 1, this.nvars );
			this.initialPopulation = zeros(1, this.nvars );
			this.hints = [];
		end % constructor

	end
	
	% Final public methods
	methods (Sealed = true, Access = public)
		% ======================================================================
        %> @brief Returns bounds for optimizers that need it
        %>
        %> @retval LB lower bound
        %> @retval UB upper bound
        % ======================================================================
		[LB UB] = getBounds(this)

		% ======================================================================
        %> @brief Sets bounds for optimizers that need it
        %>
        %> @param LB lower bound
        %> @param UB upper bound
        % ======================================================================
		this = setBounds(this, LB, UB)

		% ======================================================================
        %> @brief Gets the starting positions for the search
        %>
        %> @retval startx matrix of initial values
        % ======================================================================
		startx = getInitialPopulation(this)

		% ======================================================================
        %> @brief Sets the starting positions for the search
        %>
        %> @param pop matrix of initial values
        % ======================================================================
		this = setInitialPopulation(this,pop)

		% ======================================================================
        %> @brief Returns the number of input variables
        %>
        %> @retval nvars Number of input variables
        % ======================================================================
		nvars = getInputDimension(this)

		% ======================================================================
        %> @brief Returns the number of cost functions
        %>
        %> @retval nobjectives Number of cost functions
        % ======================================================================
		nobjectives = getOutputDimension(this)

		% ======================================================================
        %> @brief Sets the number of input and output dimensions
        %>
        %> @param inDim Number of input variables
        %> @param outDim Number of cost functions
        % ======================================================================
		this = setDimensions(this,inDim,outDim)

		% ======================================================================
        %> @brief Gives a hint to the optimizer
        %>
        %> @param key property name
        %> @param value property value
        % ======================================================================
		this = setHint( this, key, value )
		
		% ======================================================================
        %> @brief Gets a hint to the optimizer
        %>
        %> @param key property name
        %> @retval value property value
        % ======================================================================
		value = getHint( this, key )
		
        % ======================================================================
        %> @brief Sets some extra information
        %>
        %> @param state structure
        % ======================================================================
		function this = setState(this, state)
			this.state = state;
        end
		
        % ======================================================================
        %> @brief Gets some extra information
        %>
        %> @retval state structure
        % ======================================================================
		function state = getState(this)
			state = this.state;
		end
   end % sealed methods
   
	% Overridable methods, these CAN be implemented
	methods (Access = public)
		
		% ======================================================================
        %> @brief Get the number of individuals in the population
        %>
        %> @retval size Population size
        % ======================================================================
		size = getPopulationSize(this);

		% ======================================================================
        %> @brief Sets input constraints
        %>
        %> @param con constraint objects (cell array)
        % ======================================================================
		this = setInputConstraints( this, con );
        
	end % Overridable functions with standard implementation
	
   	% Abstract methods, these MUST be implemented
	methods (Abstract = true, Access = public)
		% ======================================================================
        %> @brief This function optimizes the given function handle,
		%> subject to constraints
        %>
        %> @param arg function handle
        %> @retval x optimal input point(s)
        %> @retval fval optimal function value(s)
        % ======================================================================
		[this, x, fval] = optimize(this, arg );
	end % public abstract methods
end
