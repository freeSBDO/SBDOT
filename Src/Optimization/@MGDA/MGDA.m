classdef MGDA < handle
    % MGDA
    % Multiple Gradient Descent Algorithm for Multipoint problem
    %
    % obj = MGDA( function_name, x_start, lb, ub, varargin)
    %
    % Mandatory inputs :
    %   - function_name is a string or function handle of numerical model to call for evaluation
    %   - x_start is the starting point of the algorithm (1 by m_x)
    %   - lb is the lower bound of input space (row vector 1 by m_x)
    %   - ub is the upper bound of input space (row vector 1 by m_x)
    %
    % Optional inputs [default value]:
    %   - parallel is a boolean for parallel evaluation of function_name (true = allowed)
    %   [false]
    %   - display is a boolean for displaying information (true = allowed)
    %   [true]
    %   - TOL is the tolerance parameter for descent direction
    %   [0]
    %   - iter_max is the maximum number of iterations
    %   [100]
    %   - grad_available is a boolean to indicate if gradient is evaluated by the function file
    %   If true, the function file has a second output with the gradient,
    %   otherwise it is estimated by finite difference
    %   [false]
    %   - finite_diff_step is a row vector of finite difference step value per parameter
    %   [1e-6, ... ,1e-6]
    
    properties
        
        % Mandatory inputs 
        function_name    % String or function handle for numerical model evaluation
        x_start          % Point to start the optimization
        lb               % Lower bound of the input space
        ub               % upper bound of the input space
        
        % Optional inputs (varargin) 
        display          % Logical value for displaying information during optimization
        parallel         % Logical value for allowing parallel evaluation of the function file
        TOL              % The tolerance value for descent direction condition
        iter_max         % Maximum number of allowed iterations
        grad_available   % Logcical value to indicate if gradient is evaluated by the function file
        finite_diff_step % Vector of finite difference step value per parameter
        
        % Computed variables
        m_x              % Dimension of the input space
        x_iter           % Inputs value at the current iteration
        y_iter           % Objectives values at the current iteration
        grad_iter        % Gradients values at the current iteration
        iter             % Current iteration number
        step_current     % Current step for the descent algorithm
        f_call           % Number of function calls to the function file
        hist             % Optimization history structure
        stop_opt         % Logical value for MGDA optimization stop flag
        stop_step        % Logical value for step optimization stop flag
        failed           % Logical value to indicate failure during optimization
        error            % Structure with error information if failure appends
        x_min            % Input of the minimum value at the end of the optimization
        y_min            % Objectives value at the end of the optimization
    end
    
    methods
        
        function obj=MGDA(function_name,x_start,lb,ub,varargin)
            % Constructor of the object
            % Definition is in the main MGDA help
            
            % Parser
            obj.m_x=size(x_start,2);
            p = inputParser;
            p.KeepUnmatched=true;
            p.PartialMatching=false;
            p.addRequired('function_name',@(x)validateattributes(x,{'function_handle','char'},{'nonempty'}))
            p.addRequired('x_start',@(x)validateattributes(x,{'numeric'},{'nonempty','row'}))
            p.addRequired('lb',@(x)validateattributes(x,{'numeric'},{'nonempty','row'}))
            p.addRequired('ub',@(x)validateattributes(x,{'numeric'},{'nonempty','row'}))
            p.addOptional('display',true,@islogical);
            p.addOptional('parallel',false,@islogical);
            p.addOptional('TOL',0,@isnumeric);
            p.addOptional('iter_max',100,@isnumeric);
            p.addOptional('grad_available',false,@islogical);
            p.addOptional('finite_diff_step',1e-6.*ones(1,obj.m_x),@(x)validateattributes(x,{'numeric'},{'nonempty','row'}));
            p.parse(function_name,x_start,lb,ub,varargin{:})
            in=p.Results;
            unmatched_params=fieldnames(p.Unmatched);
            
            % Checks
            for i=1:length(unmatched_params)
                warning(['Options ''' unmatched_params{i} ''' was not recognized']);
            end
            assert( size(lb,2) == obj.m_x, ...
                'SBDOT:Problem:lb_argument', ...
                'lb must be a row vector of the same size as x_start');
            assert( size(ub,2) == obj.m_x, ...
                'SBDOT:Problem:ub_argument', ...
                'ub must be a row vector of the same size as x_start');
            
            % Store
            obj.function_name = in.function_name;
            obj.x_start = in.x_start;
            obj.lb = in.lb;
            obj.ub = in.ub;
            obj.display = in.display;
            obj.parallel = in.parallel;
            obj.grad_available = in.grad_available;
            obj.iter_max = in.iter_max;
            obj.finite_diff_step = in.finite_diff_step;
            if obj.display
                if isa(obj.function_name,'function_handle'), f_text=func2str(obj.function_name);else f_text=obj.function_name; end
                fprintf(['MGDA initialized on ',f_text,' at ',num2str(x_start),'.\n'])
                if obj.grad_available, fprintf(['Gradient is given by ',f_text,'.\n']); else fprintf('Gradient is evaluated by finite difference.\n'); end
            end
            
            % Initialize parameters
            obj.failed = false;
            obj.stop_opt = false;
            obj.iter = 0;
            obj.f_call = 0;
            obj.x_iter = obj.x_start;
            obj.hist.x = [];
            obj.hist.y = [];
            
            % Launch optimization
            obj.Opt();
            
        end
        
        [] = Opt( obj );
        [ grad_shared ] = Get_grad_shared( obj, grad_matrix, options );
        [ y_eval, grad_eval ] = Eval_function( obj, x_eval );
        [ x_finite_diff ] = Get_x_finite_diff( obj, x_eval )
        [ g, i_permute, C ] = permute_info( ~, i_perm1, i_perm2, i_permute, g, C );
        
    end
    
    
    
end

