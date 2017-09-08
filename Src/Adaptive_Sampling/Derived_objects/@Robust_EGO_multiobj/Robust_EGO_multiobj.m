classdef Robust_EGO_multiobj < Robust_EGO
    % ROBUST_EGO 
    % EGO for robust optimization
    
    properties
        
    end
        
    methods
        
        function obj = Robust_EGO_multiobj(prob,y_ind,g_ind,meta_type,robust_def,CRN_samples,varargin)
            
            % Superclass constructor
            obj@Robust_EGO(prob,y_ind,g_ind,meta_type,robust_def,CRN_samples,varargin{:});
                        
        end
        
    end  
    
end

