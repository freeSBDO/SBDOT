%> @file "@MatlabOptimizer/MatlabOptimizer.m"
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
%>	MatlabOptimizer
%
% ======================================================================
%> @brief Wrapper around the matlab optimizers
%>
%> The matlab Optimiation toolbox is required.
%> If no bounds are set 'fmincon' will be used, else 'fminunc'.
% ======================================================================
classdef MatlabOptimizer < ooDACE.Optimizer
    
	% private members
	properties (SetAccess = 'private', GetAccess = 'private')
		opts;
		Aineq;
		Bineq;
		nonlcon;
        
        debug = false;
	end
	
	methods

		% ======================================================================
        %> @brief Creates an MatlabOptimizer object.
        %>
        %> Takes the same option as the base class +
        %> an options structure (see optimset)
        %>
        %> @param nvars Number of dimensions
        %> @param nobjectives Number of cost functions
        %> @param options Option structure
        %> @return instance of the Optimizer class
        % ======================================================================
		function this = MatlabOptimizer(varargin)
			% call superclass
			this = this@ooDACE.Optimizer(varargin{:});
			
            % FMINUNC/FMINCON
            % http://www.mathworks.com/access/helpdesk/help/toolbox/optim/ug/index.html?/access/helpdesk/help/toolbox/optim/ug/f3137.html
                
            % Initialise OPTIMISER opts

			% default case
            if(nargin == 1)
                config = varargin{1};

                % Create custom options structure
                opts.MaxIter = config.self.getIntOption('maxIterations', 100);
                opts.MaxFunEvals = config.self.getIntOption('maxFunEvals', 100);
                opts.LargeScale = char(config.self.getOption('largeScale', 'off'));
                opts.TolFun = config.self.getDoubleOption('functionTolerance', 1e-4);
				opts.GradObj = char(config.self.getOption('gradobj', 'off'));
                opts.Algorithm = char(config.self.getOption('algorithm','active-set'));

                opts.Diagnostics = char(config.self.getOption('diagnostics', 'off'));
				opts.DerivativeCheck = char(config.self.getOption('derivativecheck', 'off'));
                
                this.debug = config.self.getBooleanOption('debug', false);
            elseif(nargin == 3)
				% First 2 are parsed by base class
				%nvar = varargin{1};
				%nobj = varargin{2};
				opts = varargin{3};
			else
				error('Invalid number of arguments given');
            end

            % Dont show any output
            opts.Display = 'off';
			this.opts = opts;
			this.Aineq = [];
			this.Bineq = [];
			this.nonlcon = [];
		end % constructor

        [this, xmin, fmin] = optimize(this, arg );
		this = setInputConstraints( this, con );

	end % methods
end % classdef
