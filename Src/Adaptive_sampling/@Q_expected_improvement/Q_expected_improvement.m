classdef Q_expected_improvement < Expected_improvement
    
    methods
        
        function obj = Q_expected_improvement(varargin)
            
            % Superclass constructor
            obj@Expected_improvement(varargin{:});
            
        end
        
        [] = Find_min_value( obj );    
        [] = Opt( obj );
        EI_temp = Opt_crit( obj, EI_temp );
        
    end  

end