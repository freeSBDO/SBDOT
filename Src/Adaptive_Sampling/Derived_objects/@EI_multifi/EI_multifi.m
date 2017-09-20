classdef EI_multifi < Expected_improvement
    
    
    properties
        
        eval_type = 'HF'
        
    end
    
    methods
        
        function obj = EI_multifi(varargin)
            
            % Superclass constructor
            obj@Expected_improvement(varargin{:});
            
        end
        
        [] = Find_min_value( obj );    
        
    end  

end