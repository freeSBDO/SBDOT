classdef Gutmann_multifi < Gutmann_RBF
    
    
    properties
        
        eval_type = 'HF'
        
    end
    
    methods
        
        function obj = Gutmann_multifi(varargin)
            
            % Superclass constructor
            obj@Gutmann_RBF(varargin{:});
            
        end
        
        [] = Find_min_value( obj );    
        
    end  

end