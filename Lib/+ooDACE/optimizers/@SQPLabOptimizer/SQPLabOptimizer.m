%> @file "@SQPLabOptimizer/SQPLabOptimizer.m"
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
%>	SQPLabOptimizer
%
% ======================================================================
%> @brief Wrapper around the SQPLab optimization package.
% ======================================================================
classdef SQPLabOptimizer < Optimizer

% private members
	properties (SetAccess = 'private', GetAccess = 'private')
		opts;
	end
	
	methods
		% ======================================================================
        %> @brief Class constructor
        %> @return instance of the class
        % ======================================================================
		function this = SQPLabOptimizer(varargin)
			% call superclass
			this = this@Optimizer(varargin{:});

			% the Hessian of lagrangian:
			% its positive definiteness is maintained by the Wolfe line-search when there is no constraint and by the Powell correction otherwise), 
			options.algo_descent = 'Powell'; % Wolfe
			
			options.algo_globalization = 'linesearch';
			options.algo_method = 'quasi-Newton';

			if nargin == 1
				%Update defaults
				config = varargin{1};
				options.algo_descent = char( config.self.getOption('algo_descent', 'Powell') );
				options.algo_globalization = char( config.self.getOption('algo_globalization', 'linesearch' ) );
				options.algo_method = char( config.self.getOption('algo_method', 'quasi-Newton') );
			elseif nargin == 3
				[info options] = sqplab_options( struct(), varargin{3} );
			end
			
			this.opts = options;
        end
        
        [this, x, fval] = optimize(this, arg );
			
	end
end
