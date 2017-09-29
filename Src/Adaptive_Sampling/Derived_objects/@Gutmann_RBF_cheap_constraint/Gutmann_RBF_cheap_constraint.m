classdef Gutmann_RBF_cheap_constraint < Gutmann_RBF
    % EI_CHEAP_CONSTRAINT
    %
    
    properties
        
        func_cheap
        feas_point
        
    end
    
    methods
        
        function obj = Gutmann_RBF_cheap_constraint(prob,y_ind,g_ind,meta_type,func_cheap,feas_point,varargin)
            
            p = inputParser;
            p.KeepUnmatched = true;
            p.PartialMatching = false;
            p.addRequired('func_cheap',@(x)validateattributes(x,{'function_handle','char'},{'nonempty'}));
            p.addRequired('feas_point',@(x)isnumeric(x));
            p.parse(func_cheap,feas_point)
            in = p.Results;
            
            % Superclass constructor
            obj@Gutmann_RBF(prob,y_ind,g_ind,meta_type,varargin{:});
            
            obj.func_cheap = in.func_cheap;   
            obj.feas_point = in.feas_point; 
                        
        end
        
        [ crit ] = Gutmann_crit( obj, x ,min_target )
        [ y_pred ] = Obj_predict( obj, x )
        [] = Opt_crit( obj )
        
    end  
    
end

