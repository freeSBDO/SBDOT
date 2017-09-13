classdef EI_cheap_constraint < Expected_improvement
    % EI_CHEAP_CONSTRAINT
    %
    
    properties
        
        func_cheap
        
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
        
    end
    
end

