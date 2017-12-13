classdef EI_times_PF < Expected_improvement
    % EI_TIMES_PF Summary of this class goes here
    % Efficient Global Optimization algorithm.
    % Single objective kriging (or cokriging) based constrained optimization method.
    % When the sub-optimization problem criterion is EIxPF (unconstrained)
    %
    % obj = EI_times_PF(prob, y_ind, g_ind, meta_type, varargin)
    %
    % Mandatory inputs :
    %   * see Expected_improvement help
    %
    % Optional inputs [default value]:
    %   * see Expected_improvement help
    
    properties
    end
    
    methods
        
        function obj = EI_times_PF(prob,y_ind,g_ind,meta_type,varargin)
            
            assert( isempty(g_ind) == 0,...
                'SBDOT:EI_times_PF:g_ind_empty',...
                'EI_times_PF is equivalent to Expected_improvement when the optimization problem is unconstrained');
                        
            %Superclass constructor
            obj@Expected_improvement(prob,y_ind,g_ind,meta_type,varargin{:}); 
                        
        end
    end
    
    
    
end

