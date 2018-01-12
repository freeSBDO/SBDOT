classdef Problem_multifi < handle
    % PROBLEM_MULTIFI class
    % Define the features of the model to later use for multifidelity 
    % metamodeling or optimization purpose.
    %
    % obj = Problem_multifi( prob_LF, prob_HF )
    %
    % Mandatory inputs :
    %   - prob_LF is a Problem object of the low fidelity model
    %   - prob_HF is a Problem object of the high fidelity model
    %
        
    properties
        
        % Mandatory inputs
        prob_HF     % High fidelity model Problem object
        prob_LF     % Low fidelity model Problem object
        
        % Constructed inputs
        display     % Logical, displaying information (true = allowed)
        m_x         % Dimension of the input space
        m_y         % Number of objectives
        m_g         % Number of contraints                
        lb          % Lower bound of input space (row vector 1 by m_x)
        ub          % Upper bound of input space (row vector 1 by m_x)
        
    end
    
    methods
        
        function obj = Problem_multifi( prob_LF, prob_HF )
            % Problem_multifi constructor
            % Initialized a Problem_multifi object with mandatory inputs :
            % 	obj=Problem( prob_LF, prob_HF)
            
            % Parser for input validation
            p = inputParser;
            p.KeepUnmatched = true;
            p.PartialMatching = false;
            p.addRequired('prob_LF',@(x)isa(x,'Problem'))
            p.addRequired('prob_HF',@(x)isa(x,'Problem'))
            p.parse( prob_LF, prob_HF)
            in = p.Results;
                                        
            % Store            
            obj.prob_LF = in.prob_LF;
            obj.prob_HF = in.prob_HF;
            
            % Check that HF and LF problem have the same parameters
            obj.Check_pb();
            
            obj.display = obj.prob_HF.display;
            obj.prob_LF.display = false;
            obj.prob_HF.display = false;
            
            % Display
            if obj.display
                fprintf(['\nMultifidelity Problem object successfully constructed with: \n',...
                    num2str(obj.m_x),' design variable(s), ',...
                    num2str(obj.m_y),' objective(s) and ',...
                    num2str(obj.m_g),' constraint(s).\n\n'])
            end
            
        end
        
        [] = Sampling( obj, num_x_LF, num_x_HF, type );
        
        [ y_eval, g_eval, x_eval ] = Eval( obj, x_eval, which_pb );
        
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


