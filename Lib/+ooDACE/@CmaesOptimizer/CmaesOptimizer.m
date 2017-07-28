classdef CmaesOptimizer < ooDACE.Optimizer
    
	% private members
	properties (SetAccess = 'private', GetAccess = 'private')
		opt;
	end
	
	methods

		function this = CmaesOptimizer(varargin)
			% call superclass
			this = this@ooDACE.Optimizer(varargin{:});
			
			% default case
            if(nargin == 1)
                config = varargin{1};

                % Create custom options structure
                this.opt.TolX = 1e-4;
                this.opt.Restarts = 2;
                this.opt.IncPopSize = 2;
                this.opt.TolFun = 1e-4;
                this.opt.DispModulo = 0;
                
                this.debug = config.self.getBooleanOption('debug', false);
            elseif(nargin == 3)
				% First 2 are parsed by base class
				%nvar = varargin{1};
				%nobj = varargin{2};
				this.opt = varargin{3};
			else
				error('Invalid number of arguments given');
            end

		end % constructor

        [this, xmin, fmin] = optimize(this, arg );

	end % methods
end % classdef
