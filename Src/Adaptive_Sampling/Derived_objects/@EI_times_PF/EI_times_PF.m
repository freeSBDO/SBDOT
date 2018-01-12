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


