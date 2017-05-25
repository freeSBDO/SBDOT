classdef Problem < handle
    % PROBLEM class
    % Define the features of the model to later use for metamodeling or
    % optimization purpose.
        
    properties ( Access = public )
        
        % Mandatory inputs 
        function_name % String or function handle of numerical model
        m_x           % Dimension of the input space
        m_y           % Number of objectives
        m_g           % Number of contraints                
        lb            % Lower bound of input space (row vector 1 by m_x)
        ub            % Upper bound of input space (row vector 1 by m_x)
        
        % Optional inputs (varargin) 
        parallel      % Logical, parallel evaluation of function_name (true = allowed)
        display       % Logical, displaying information (true = allowed)
        round         % Logical, rounding input values before evaluation (true = to round)
        round_range   % Rounding range for input values (only if round is true)
        Tol_eval      % Tolerance value on distance between already evaluated points and new one.

        % Computed variables
        n_x = 0      % Number of points        
        x = []        % Matrix of input points (n_x by m_x)
        y = []        % Corresponding objectives values (n_x by m_y)
        g = []        % Corresponding contraints values (n_x by m_g)
        
    end
    
    methods ( Access = public )
        
        function obj=Problem(function_name,m_x,m_y,m_g,lb,ub,varargin)
            % Problem constructor
            % Initialized a problem object with mandatory inputs :
            % 	obj=Problem(function_name,m_x,m_y,m_g,lb,ub)
            %
            % Initialized a problem object with mandatory inputs :
            % 	obj=Problem(function_name,m_x,m_y,m_g,lb,ub,varargin)
            %   obj=Problem(function_name,m_x,m_y,m_g,lb,ub,'parallel',true)
            %
            % Optionnal inputs [default value] :
            %	'parallel'    [false]
            %	'display'     [true]
            %	'round'       [false]
            %	'round_range' []
            %   'Tol_eval'    [1e-4]
            
            % Parser for input validation
            p = inputParser;
            p.KeepUnmatched=true;
            p.PartialMatching=false;
            p.addRequired('function_name',@(x)validateattributes(x,{'function_handle','char'},{'nonempty'}))
            p.addRequired('m_x',@(x)validateattributes(x,{'numeric'},{'nonempty','scalar','integer','positive'}))
            p.addRequired('m_y',@(x)validateattributes(x,{'numeric'},{'nonempty','scalar','integer','positive'}))
            p.addRequired('m_g',@(x)validateattributes(x,{'numeric'},{'nonempty','scalar','integer','nonnegative'}))
            p.addRequired('lb',@(x)validateattributes(x,{'numeric'},{'nonempty','row'}))
            p.addRequired('ub',@(x)validateattributes(x,{'numeric'},{'nonempty','row'}))
            p.addOptional('parallel',false,@islogical);
            p.addOptional('display',true,@islogical);
            p.addOptional('round',false,@islogical);
            p.addOptional('round_range',[],@isnumeric);
            p.addOptional('Tol_eval',1e-4,@isnumeric);
            p.parse(function_name,m_x,m_y,m_g,lb,ub,varargin{:})
            in=p.Results;
            
            % Checks
            unmatched_params=fieldnames(p.Unmatched);            
            for i=1:length(unmatched_params)
                warning('SBDOT:Problem:unmatched', ... 
                    ['Options ''' unmatched_params{i} ''' was not recognized']);
            end
            assert(size(lb,2)==in.m_x,...
                'SBDOT:Problem:lb_argument',...
                'lb must be a row vector of size 1 by m_x');
            assert(size(ub,2)==in.m_x,...
                'SBDOT:Problem:ub_argument',...
                'ub must be a row vector of size 1 by m_x');
            
            % Store            
            obj.function_name=in.function_name;
            obj.m_x=in.m_x;
            obj.m_y=in.m_y;
            obj.m_g=in.m_g;
            obj.lb=in.lb;
            obj.ub=in.ub;
            obj.parallel=in.parallel;
            obj.display=in.display;
            obj.round=in.round;
            obj.round_range=in.round_range;
            obj.Tol_eval=in.Tol_eval;
            
            % Display
            if obj.display
                fprintf(['\nProblem object successfully constructed with: \n',...
                    num2str(obj.m_x),' design variable(s), ',...
                    num2str(obj.m_y),' objective(s) and ',...
                    num2str(obj.m_g),' constraint(s).\n\n'])
            end
            
        end
        
        [ y_eval, g_eval, x_eval ] = Eval( obj, x_eval );
        
        [] = Sampling( obj, num_x, type, force_unlicenced );
        
        [] = Add_data(obj,x_add,y_add,g_add);
        
    end
    
    methods ( Access = protected )
        
        n_eval = Input_assert( obj, x_eval );
        
        [] = Output_assert( obj, y_eval, g_eval);
        
        [] = Eval_error_handling( obj, ME, x_eval);
        
    end
    
end

