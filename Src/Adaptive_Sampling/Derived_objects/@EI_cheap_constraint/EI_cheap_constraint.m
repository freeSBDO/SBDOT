classdef EI_cheap_constraint < Expected_improvement
    % EI_CHEAP_CONSTRAINT
    % Efficient Global Optimization algorithm.
    % Single objective kriging (or cokriging) based optimization method.
    % When cheap to call constraint function is available
    %
    % obj = EI_cheap_constraint(prob, y_ind, g_ind, meta_type, func_cheap, varargin)
    %
    % Mandatory inputs :
    %   * see Expected_improvement help
    %   - func_cheap is a string or function handle of numerical model to call for 
    %   cheap constraint evaluation.
    %
    % Optional inputs [default value]:
    %   * see Expected_improvement help
    
    properties
        
        func_cheap % String or function handle of cheap constraint model
        
    end
    
    methods
        
        function obj = EI_cheap_constraint(prob,y_ind,g_ind,meta_type,func_cheap,varargin)
            
            p = inputParser;
            p.KeepUnmatched = true;
            p.PartialMatching = false;
            p.addRequired('func_cheap',@(x)validateattributes(x,{'function_handle','char'},{'nonempty'}));
            p.parse(func_cheap)
            in = p.Results;
            
            % Superclass constructor
            obj@Expected_improvement(prob,y_ind,g_ind,meta_type,varargin{:});
            
            obj.func_cheap = in.func_cheap;   
                        
        end
        
        [ EI_val] = EI_unconstrained( obj, x_test )
        [ EI_val, cons ] = EI_constrained( obj, x_test )
        [] = Opt_crit( obj )
        
    end
    
end

