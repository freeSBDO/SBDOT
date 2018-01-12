classdef Gutmann_multifi < Gutmann_RBF
    % GUTMANN_MULTIFI
    % Gutmann optimization algorithm with CoRBF
    % Single objective co-RBF based optimization method.
    % unconstrained or constrained problems.
    % 
    % obj = Gutmann_multifi(prob, y_ind, g_ind, meta_type, varargin)
    %    
    % Mandatory inputs :
    %   * see Gutmann_RBF help
    %   - meta_type is the type of metamodel to use @CoRBF
    %
    % Optional inputs [default value]:
    %   * see Gutmann_RBF help
    %
    
    properties
        
        eval_type = 'HF' % Define which model to evaluate
        
    end
    
    methods
        
        function obj = Gutmann_multifi(varargin)
            
            % Superclass constructor
            obj@Gutmann_RBF(varargin{:});
            
        end
        
        [] = Find_min_value( obj );    
        
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


