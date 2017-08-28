classdef Q_multi_obj_EI_MGDA < Multi_obj_EI_MGDA
    % MULTI_OBJ_EI_MGDA 
    % Kriging-based MGDA
    
    methods
        
        function obj = Q_multi_obj_EI_MGDA(varargin)
            
            % Superclass constructor
            obj@Multi_obj_EI_MGDA(varargin{:});
             
        end
        
        [] = Opt_crit( obj );
        [] = Find_min_value( obj );
        [ EI_val, grad_EI ] = Obj_func_EI( obj, x_test );
        y_obj = Obj_func_nsga( obj, x_test );
        
    end
    
end

