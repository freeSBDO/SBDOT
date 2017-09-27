classdef Adaptive_sampling < handle 
    %ADAPTIVE_SAMPLING Class
    % Define basics features of all adaptive sampling algorithms. 
    % Use as superclass, do not instantiate directly.
    
    properties ( Access = public )
        
        % Mandatory inputs 
        prob % object of the whole conception problem        
        y_ind %labels number of problem objectives selected
        g_ind %labels number of problem constraints selected
                
        % Optional inputs (varargin) 
        iter_max % Maximum number of iterations
        fcall_max % Maximum number of functions calls
        
        % Computed variables        
        m_y % number of objective
        m_g % number of constraint
        meta_y % objective metamodel information
        meta_g % contraint metamodel information 
        
        display_temp % Temporary variable for display purpose
        
        x_new % new point to evaluate        
        
        y_min % objective value of the actual minimum
        g_min % contraint value of the actual minimum
        x_min % input value of the actual minimum
        loc_min % location in the dataset of the minimum                
        
        failed % Logical value for failing mode
        opt_stop % Logical value for stoping flag
        crit_stop % Logical value for crit stoping flag
        iter_num % Current iteration
        fcall_num % Current number of function calls
        
        error % Structure of error info
        hist % History structure
        unmatched_params % unmatched_params
        
    end
    
    methods (Abstract)
       
        Opt_crit(obj); % Main method (in subclass)
        Conv_check_crit(obj); % Check convergence
        
    end
    
    methods
        
        function obj = Adaptive_sampling( prob, y_ind, g_ind, varargin )            
            % Adaptive_sampling constructor
            % Initialized a adaptive_sampling object with mandatory inputs :
            % 	obj=Adaptive_sampling(prob,y_ind,g_ind)
            %
            % Initialized a problem object with optionnal inputs :
            % 	obj=Adaptive_sampling(prob,y_ind,g_ind,varargin)
            %   obj=Adaptive_sampling(prob,y_ind,g_ind,'iter_max',10)
            %
            % Optionnal inputs [default value] :
            %	'iter_max'    []
            %	'fcall_max'   [50]
            
            p = inputParser;
            p.KeepUnmatched = true;
            p.PartialMatching = false;
            p.addRequired('prob',@(x)isa(x,'Problem') || isa(x,'Problem_multifi'));
            p.addRequired('y_ind',@(x)isnumeric(x) && isrow(x))
            p.addRequired('g_ind',@(x)isnumeric(x) && (isrow(x) || isempty(x)))
            p.addOptional('iter_max',50,@(x)(x == floor(x))&&(isempty(x)||isscalar(x)));
            p.addOptional('fcall_max',[],@(x)(x == floor(x))&&(isempty(x)||isscalar(x)));
            p.parse(prob,y_ind,g_ind,varargin{:})
            in = p.Results;
            unmatched = [fieldnames(p.Unmatched),struct2cell(p.Unmatched)];
            obj.unmatched_params = unmatched'; % Save unmatched inputs for further use 
                        
            % Store
            obj.prob = in.prob;
            obj.y_ind = in.y_ind;
            obj.g_ind = in.g_ind;            
            obj.iter_max = in.iter_max;  
            obj.fcall_max = in.fcall_max;
            
            % Number of objectives and constraint
            obj.m_y = length( y_ind );
            obj.m_g = length( g_ind );
            
            % Adaptive_sampling display only
            obj.display_temp = obj.prob.display;
            obj.prob.display = false;
            if isa( obj.prob , 'Problem_multifi')
                obj.prob.prob_HF.display = false;
                obj.prob.prob_LF.display = false;
            end
            
            % Initialize stoping/failing/iter
            obj.failed = false;
            obj.opt_stop = false;
            obj.crit_stop = false;
            obj.iter_num = 0;      
            obj.fcall_num = 0; 
            
            % Initialize Metamodel
            obj.meta_y = struct();
            obj.meta_g = struct();
            
            % Initialize history storage
            obj.hist.x=[];
            obj.hist.y=[];
            obj.hist.g=[];
            obj.hist.crit=[];
            obj.hist.x_min=[];
            obj.hist.y_min=[];
            obj.hist.g_min=[]; 
            
        end
        
        [] = Conv_check( obj );
        [] = Opt( obj );
        [] = Eval( obj );
        [] = Restart( obj, iter_sup, fcall_sup );
        [X_filter] = K_filtering( obj, x_new );
        
    end
    
end

