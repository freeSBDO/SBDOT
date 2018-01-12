classdef Problem < handle
    % PROBLEM class
    % Define the features of the model to later use for metamodeling or
    % optimization purpose.
    %
    % obj = Problem( function_name, m_x, m_y, m_g, lb, ub, varargin )
    %
    % Mandatory inputs :
    %   - function_name is a string or function handle of numerical model to call for evaluation
    %   - m_x is the dimension of the input space
    %   - m_y is the number of objectives
    %   - m_g is the number of contraints
    %   - lb is the lower bound of input space (row vector 1 by m_x)
    %   - ub is the upper bound of input space (row vector 1 by m_x)
    %
    % Optional inputs [default value]:
    %   - parallel is a boolean for parallel evaluation of function_name (true = allowed)
    %   [false]
    %   - display is a boolean for displaying information (true = allowed)
    %   [true]
    %   - round is a boolean for rounding input values before evaluation (true = to round)
    %   [false] 
    %   - round_range is the rounding range for input values (only if round is true)
    %   [] see Round_data in Tools for settings
    %   - tol_eval is the tolerance value on distance between already evaluated points and new one.
    %   [1e-4]
    %   - save_file is the filename for .mat save of evaluations (save only if not empty)
    %   []
    %
        
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
        tol_eval      % Tolerance value on distance between already evaluated points and new one.
        save_file     % Filename for .mat save of evaluations

        % Computed variables
        n_x = 0      % Number of points        
        x = []        % Matrix of input points (n_x by m_x)
        y = []        % Corresponding objectives values (n_x by m_y)
        g = []        % Corresponding contraints values (n_x by m_g)
        
    end
    
    methods ( Access = public )
        
        function obj = Problem( function_name, m_x, m_y, m_g, lb, ub, varargin )
            % Problem constructor
            % Initialized a problem object with mandatory inputs :
            % 	obj=Problem(function_name,m_x,m_y,m_g,lb,ub)
            %
            % Initialized a problem object with optionnal inputs :
            % 	obj=Problem(function_name,m_x,m_y,m_g,lb,ub,varargin)
            %   obj=Problem(function_name,m_x,m_y,m_g,lb,ub,'parallel',true)
            %
            % Optionnal inputs [default value] :
            %	'parallel'    [false]
            %	'display'     [true]
            %	'round'       [false]
            %	'round_range' []
            %   'tol_eval'    [1e-4]
            %   'save_file'    []
            
            % Parser for input validation
            p = inputParser;
            p.KeepUnmatched = true;
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
            p.addOptional('tol_eval',1e-4,@isnumeric);
            p.addOptional('save_file',[],@ischar);
            p.parse(function_name,m_x,m_y,m_g,lb,ub,varargin{:})
            in = p.Results;
            
            % Checks
            unmatched_params = fieldnames(p.Unmatched);            
            for i=1:length(unmatched_params)
                warning('SBDOT:Problem:unmatched', ... 
                    ['Options ''' unmatched_params{i} ''' was not recognized']);
            end
            assert( size(lb,2) == in.m_x,...
                'SBDOT:Problem:lb_argument',...
                'lb must be a row vector of size 1 by m_x');
            assert( size(ub,2) == in.m_x,...
                'SBDOT:Problem:ub_argument',...
                'ub must be a row vector of size 1 by m_x');
            assert( all( lb < ub , 2),...
                'SBDOT:Problem:bounds',...
                'lb must be lower than ub');
            
            % Store            
            obj.function_name = in.function_name;
            obj.m_x = in.m_x;
            obj.m_y = in.m_y;
            obj.m_g = in.m_g;
            obj.lb = in.lb;
            obj.ub = in.ub;
            obj.parallel = in.parallel;
            obj.display = in.display;
            obj.round = in.round;
            obj.round_range = in.round_range;
            obj.tol_eval = in.tol_eval;
            obj.save_file = in.save_file;
            
            % Display
            if obj.display
                fprintf(['\nProblem object successfully constructed with: \n',...
                    num2str(obj.m_x),' design variable(s), ',...
                    num2str(obj.m_y),' objective(s) and ',...
                    num2str(obj.m_g),' constraint(s).\n\n'])
            end
            
        end       
                
        x_sampling = Sampling( obj, num_x, type );
        
        [ y_eval, g_eval, x_eval ] = Eval( obj, x_eval );
        
        [] = Get_design( obj, num_x, type );
        
        [] = Add_data( obj, x_add, y_add, g_add);
        
    end
    
    methods ( Access = protected )
        
        n_eval = Input_assert( obj, x_eval );
        
        [] = Output_assert( obj, y_eval, g_eval);
        
        [] = Eval_error_handling( obj, ME, x_eval);
        
    end
    
end





% ==========================================================================
%
%    This file is part of SBDOT.
%
%    SBDOT is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    SBDOT is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with SBDOT.  If not, see <http://www.gnu.org/licenses/>.
%
%    Use of SBDOT is free for personal, non-profit, pure academic research
%    and educational purposes. Restrictions apply on commercial or funded
%    research use. Please read the IMPORTANT_LICENCE_NOTICE file.
%
% ==========================================================================


