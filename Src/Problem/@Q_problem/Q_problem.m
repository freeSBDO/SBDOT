classdef Q_problem < Problem
    % Q_PROBLEM class
    % Define complementary features of the qualitative model to later use for metamodeling or
    % optimization purpose.
    
    properties ( Access = public )
        
        % Mandatory Inputs
        m_t           % Vector containing the number of levels for each qualitative variable
        t             % Cell, containing the values of each qualitative variable
        
    end
    
    methods ( Access = public )

        function obj=Q_problem(function_name,t,m_x,m_y,m_g,m_t,lb,ub,varargin)
            % Q_problem constructor
            % Initialized a qualitative problem object with mandatory inputs :
            % 	obj=Q_problem(function_name,t,m_x,m_y,m_g,m_t,lb,ub)
            %
            % Initialized a problem object with optionnal inputs :
            % 	obj=Problem(function_name,t,m_x,m_y,m_g,m_t,lb,ub,varargin)
            %   obj=Problem(function_name,m_x,m_y,m_g,lb,ub,'parallel',true)
            %
            % Optionnal inputs [default value] :
            %	'parallel'    [false]
            %	'display'     [true]
            %	'round'       [false]
            %	'round_range' []
            %   'tol_eval'    [1e-4]
            %   'save_file'   []
            
            % Parser for input validation            
            p = inputParser;
            p.KeepUnmatched=true;
            p.PartialMatching=false;
            p.addRequired('m_t',@(x)validateattributes(x,{'numeric'},{'nonempty','row'}))
            p.addRequired('t',@(x)validateattributes(x,{'cell'},{'nonempty','row','size',size(m_t)}))
            p.parse(m_t,t)
            in=p.Results;
            
            % Checks
            unmatched_params = fieldnames(p.Unmatched);            
            for i=1:length(unmatched_params)
                warning('SBDOT:Q_problem:unmatched', ... 
                    ['Options ''' unmatched_params{i} ''' was not recognized']);
            end
            
            assert( all ( arrayfun(@(k) k>1, m_t) ),...
                'SBDOT:Q_problem:insuficient_levels', ...
                'Qualitative variables shall have at least 2 levels');
            
            arrayfun(@(k) validateattributes(t{k},{'numeric'},{'nonempty','column','size',[m_t(k),1]}),...
                1:size(m_t,2),'UniformOutput', false);
        
            % Store
            obj@Problem(function_name,m_x,m_y,m_g,lb,ub,varargin{:});
            obj.t = in.t;
            obj.m_t = in.m_t;
            
            % Display
            if obj.display
                fprintf(['\nQualitative Problem object successfully constructed with: \n',...
                    mat2str(obj.m_t),' qualitative variable(s), \n\n'])
            end
            
        end
        
        x_sampling = Sampling( obj, num_x, varargin );
        
        [ y_eval, g_eval, x_eval ] = Eval( obj, num_x, x_eval );
        
        [] = Get_design( obj, num_x, varargin );
        
        [] = Add_data( obj, x_add, y_add, g_add, n_add);
        
        x_sampling = SLHS( obj, num_x, varargin );
        
    end
    
    methods ( Access = protected )
        
        n_eval = Input_assert( obj, x_eval );
        
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


