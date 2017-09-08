classdef Q_expected_improvement < Expected_improvement
    
    methods
        
        function obj = Q_expected_improvement(varargin)
            
            % Superclass constructor
            obj@Expected_improvement(varargin{:});
            
        end
        
        [] = Find_min_value( obj );    
        [] = Opt_crit( obj );
        
    end  

end