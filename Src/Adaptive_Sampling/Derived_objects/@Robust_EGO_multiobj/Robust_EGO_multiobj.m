classdef Robust_EGO_multiobj < Robust_EGO
    % ROBUST_EGO
    % EGO for robust optimization
    % When robustness is evaluated from multiple objectives.
    % For examples, compute the worstace measure over the three output of
    % prob ( y_ind = [1 2 3] and robust_def.meas_type_y = 'Worstcase_meas' )
    %
    % obj = Robust_EGO_multiobj(prob, y_ind, g_ind, meta_type, robust_def, CRN_samples, varargin)
    %
    % Mandatory inputs :
    %   * see Robust_EGO help
    %
    % Optional inputs [default value]:
    %   * see Robust_EGO help
    %
    properties
        
    end
    
    methods
        
        function obj = Robust_EGO_multiobj(prob,y_ind,g_ind,meta_type,robust_def,CRN_samples,varargin)
            
            % Superclass constructor
            obj@Robust_EGO(prob,y_ind,g_ind,meta_type,robust_def,CRN_samples,varargin{:});
            
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


