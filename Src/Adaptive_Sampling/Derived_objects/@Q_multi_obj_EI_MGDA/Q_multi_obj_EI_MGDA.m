classdef Q_multi_obj_EI_MGDA < Multi_obj_EI_MGDA
    % MULTI_OBJ_EI_MGDA 
    % Kriging-based MGDA
    
    methods
        
        function obj = Q_multi_obj_EI_MGDA(varargin)
     
            % Superclass constructor
            obj@Multi_obj_EI_MGDA(varargin{:});
           
        end
        
        [] = Opt_crit( obj );
        [] = Find_min_value( obj );
        [ EI_val, grad_EI ] = Obj_func_EI( obj, x_test );
        y_obj = Obj_func_nsga( obj, x_test );
        
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


