classdef Metamodel < handle
    % METAMODEL class
    % Define basics features of all metamodel. 
    % Use as superclass, do not instantiate directly.
    
    properties ( Access = public )
        
        % Mandatory inputs
        prob           % Problem object
        y_ind          % Index of the  objective to surrogate
        g_ind          % Index of the contraint to surrogate
        
        % Optional inputs (varargin) 
        shift_output   % Vector with 2 values for scaling the output
        % First value is a scaling factor, second value is sum to the scaled output
        
        % Build
        x_train     % Input data for training (scaled)
        f_train     % Output data for training (shifted if asked)
    end
    
    methods ( Access = public )
        
        function obj = Metamodel( prob, y_ind, g_ind, varargin )
            % Metamodel constructor
            % Initialized a metamodel object with mandatory inputs :
            % 	obj=Metamodel(prob,y_ind,g_ind)
            %
            % Initialized a problem object with optionnal inputs :
            % 	obj=Metamodel(prob,y_ind,g_ind,varargin)
            %   obj=Metamodel(prob,y_ind,g_ind,'shift_output',[2 1])
            %
            % Optionnal inputs [default value] :
            %	'shift_output'    []
            
            % Parser for input validation
            p = inputParser;
            p.KeepUnmatched = true;
            p.PartialMatching = false;
            p.addRequired('prob', @(x)isa(x,'Problem') || @(x)isa(x,'Problem_multifi'));
            p.addRequired('y_ind', @(x)isnumeric(x) && (isscalar(x) || isempty(x)))
            p.addRequired('g_ind', @(x)isnumeric(x) && (isscalar(x) || isempty(x)))
            p.addOptional('shift_output', []);
            p.parse( prob, y_ind, g_ind, varargin{:} )
            in = p.Results;
                        
            % Checks 
            unmatched_params = fieldnames( p.Unmatched );
            for i = 1:length(unmatched_params)
                warning('SBDOT:Metamodel:unmatched', ... 
                    ['Options ''' unmatched_params{i} ''' was not recognized']);
            end
            assert(~(isempty(y_ind)&&isempty(g_ind)),...
                'SBDOT:Metamodel:lab_empty',...
                'y_ind and g_ind could not be both empty');
            assert(~(~isempty(y_ind)&& ~isempty(g_ind)),....
                'SBDOT:Metamodel:lab_nonempty',...
                'y_ind ou g_ind could not be both nonempty');
            
            % Store
            obj.prob = in.prob; 
            obj.y_ind = in.y_ind;
            obj.g_ind = in.g_ind;
            obj.shift_output = in.shift_output;
            
        end
        
        [] = Train( obj );
        
        [] = Update_training_data( obj );
        
        x_eval_scaled = Predict( obj, x_eval );
        
        [] = Plot( obj, inputs_index, cut_values );
        
        [] = Plot_error( obj, x, y );
        
        stat = Rmse( obj, x, y );
        stat = Nmse( obj, x, y );
        stat = Mape( obj, x, y );
        stat = Raae( obj, x, y );
        stat = Rmae( obj, x, y );
        stat = R2( obj, x, y );
        
    end
    
end
