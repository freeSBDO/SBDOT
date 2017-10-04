classdef EI_multifi < Expected_improvement
    % EI_multifi
    % Efficient Global Optimization algorithm.
    % Single objective cokriging based optimization method.
    %
    % obj = EI_multifi(prob, y_ind, g_ind, meta_type, varargin)
    %
    % Mandatory inputs :
    %   * see Expected_improvement help
    %   - meta_type is the type of metamodel to use @Cokriging 
    %
    % Optional inputs [default value]:
    %   * see Expected_improvement help
    
    properties
        
        eval_type = 'HF' % Define which model to evaluate
        
    end
    
    methods
        
        function obj = EI_multifi(varargin)
            
            % Superclass constructor
            obj@Expected_improvement(varargin{:});
            
        end
        
        [] = Find_min_value( obj );
        
    end
    
end