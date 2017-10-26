classdef Sobol < handle
    % SOBOL
    % Estimates Sobol indices (based on Saltelli et. al. 2009)
    % If input space is higher than 10, only first order and total indices
    % are computed. 
    %
    % obj = Sobol( func_obj, partial, total, varargin)
    %
    % Mandatory inputs :
    %   - func_obj is a Problem object or a Metamodel object (Kriging, RBF, ...)
    %   - partial is a scalar value for partial indices computation :
    %   0 -> no partial indices computed ; 
    %   1 -> first order only ; 
    %   2 -> all interactions computed (unreadable in high dimension) ; 
    %   if dimension > 10, only first order are computed (safety)
    %   - total is a scalar value for total indices computation :
    %   0 -> no total indices are computed ; 
    %   1 -> indices are computed ;
    %
    % Optional inputs [default value]:
    %   - n_MC is the number of points in Monte Carlo sample
    %   [Auto calibrate with input space dimension]
    %
    % See s_i and s_tot variables for indices values after computation.
    % Total indices are in ascending order.
    % Each line of the M matrix indicates which input parameters are taken
    % into account for s_i computation (see Logical_matrix method help).
    
    properties
        
        % Mandatory inputs
        func_obj  % Problem or Metamodel object
        partial   % Scalar value for partial indices computation
        total     % Scalar value for total indices computation
        
        % Optional inputs (varargin)
        n_MC      % Number of points in Monte Carlo sample
        
        % Computed variables
        m         % Dimension of input space
        M         % Logical matrix (link input variables and partial indices)
        samp_A    % Sample matrix A(see ref)
        samp_B    % Sample matrix B(see ref)
        y_A       % Evaluation of samples A
        y_B       % Evaluation of samples B
        y_var     % Variance of y_A
        s_i       % Partial indices
        s_tot     % Total indices
    end
    
    methods
        
        function obj = Sobol(func_obj,partial,total,varargin)
            % Constructor and Main method
            
            % Parser
            p = inputParser;
            p.KeepUnmatched=true;
            p.PartialMatching=false;
            p.addRequired('func_obj',@(x)(isa(x,'Problem') || isa(x,'Metamodel')))
            p.addRequired('partial',@(x)(x == 0 || x == 1 || x == 2))
            p.addRequired('total',@(x)(x == 0 || x == 1))
            p.addOptional('n_MC',0,@isnumeric);
            p.parse(func_obj,partial,total,varargin{:})
            in=p.Results;
            
            % Store
            obj.func_obj = in.func_obj;
            obj.partial = in.partial;
            obj.total = in.total;
            obj.n_MC = in.n_MC;
            
            if isa(obj.func_obj,'Problem')
                obj.m = obj.func_obj.m_x;
            else % Metamodel
                obj.m = obj.func_obj.prob.m_x;
            end
            
            % Checks
            if obj.n_MC == 0
                obj.n_MC = 1000 * obj.m;
            end            
            if obj.n_MC < (obj.m * 1000)
                warning('Size of Monte Carlo sampling might be too small')
                warning('Sample size is now %i\n',obj.m*1000)
                obj.n_MC = 1000 * obj.m;
            end
            if obj.partial == 0 && obj.total == 0
                warning('Both partial and total indices computation are set to 0')
                warning('Nothing will be computed')
            end
            
            % Main
            
            obj.M = Logical_matrix( obj );
            
            [ obj.samp_A, obj.samp_B ] = Sampling( obj );
            
            if isa(obj.func_obj,'Problem')
                obj.y_A = obj.func_obj.Eval( obj.samp_A );
                obj.func_obj.x = [];
                obj.func_obj.y = [];
                obj.func_obj.g = [];
                obj.y_B = obj.func_obj.Eval( obj.samp_B );
                obj.func_obj.x = [];
                obj.func_obj.y = [];
                obj.func_obj.g = [];
            else % Metamodel
                obj.y_A = obj.func_obj.Predict( obj.samp_A );
                obj.y_B = obj.func_obj.Predict( obj.samp_B );
            end
            
            obj.y_var = var(obj.y_A);
            
            obj.Partial_comp();
            obj.Total_comp();
                       
        end
        
        [] = Partial_comp( obj );
        [] = Total_comp(obj);
        M = Logical_matrix( obj );
        [ A, B ] = Sampling( obj );
    end
    
end

