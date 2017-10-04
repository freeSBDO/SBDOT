classdef Gutmann_multifi < Gutmann_RBF
    % GUTMANN_MULTIFI
    % Gutmann optimization algorithm with CoRBF
    % Single objective co-RBF based optimization method.
    % unconstrained or constrained problems.
    % 
    % obj = Gutmann_multifi(prob, y_ind, g_ind, meta_type, varargin)
    %    
    % Mandatory inputs :
    %   * see Gutmann_RBF help
    %   - meta_type is the type of metamodel to use @CoRBF
    %
    % Optional inputs [default value]:
    %   * see Gutmann_RBF help
    %
    
    properties
        
        eval_type = 'HF' % Define which model to evaluate
        
    end
    
    methods
        
        function obj = Gutmann_multifi(varargin)
            
            % Superclass constructor
            obj@Gutmann_RBF(varargin{:});
            
        end
        
        [] = Find_min_value( obj );    
        
    end  

end