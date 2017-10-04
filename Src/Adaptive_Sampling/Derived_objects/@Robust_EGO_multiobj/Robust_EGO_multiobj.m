classdef Robust_EGO_multiobj < Robust_EGO
    % ROBUST_EGO
    % EGO for robust optimization
    % When robustness is evaluated from multiple objectives.
    % For examples, compute the worstace measure over the three output of
    % prob ( y_ind = [1 2 3] and robust_def.meas_type_y = 'Worstcase_meas' )
    %
    % obj = Robust_EGO_multiobj(prob, y_ind, g_ind, meta_type, robust_def, CRN_samples, varargin)
    %
    % Mandatory inputs :
    %   * see Robust_EGO help
    %
    % Optional inputs [default value]:
    %   * see Robust_EGO help
    %
    properties
        
    end
    
    methods
        
        function obj = Robust_EGO_multiobj(prob,y_ind,g_ind,meta_type,robust_def,CRN_samples,varargin)
            
            % Superclass constructor
            obj@Robust_EGO(prob,y_ind,g_ind,meta_type,robust_def,CRN_samples,varargin{:});
            
        end
        
    end
    
end

