classdef EI_cheap_constraint < Expected_improvement
    % EI_CHEAP_CONSTRAINT
    % Efficient Global Optimization algorithm.
    % Single objective kriging (or cokriging) based optimization method.
    % When cheap to call constraint function is available
    %
    % obj = EI_cheap_constraint(prob, y_ind, g_ind, meta_type, func_cheap, varargin)
    %
    % Mandatory inputs :
    %   * see Expected_improvement help
    %   - func_cheap is a string or function handle of numerical model to call for 
    %   cheap constraint evaluation.
    %
    % Optional inputs [default value]:
    %   * see Expected_improvement help
    
    properties
        
        func_cheap % String or function handle of cheap constraint model
        
    end
    
    methods
        
        function obj = EI_cheap_constraint(prob,y_ind,g_ind,meta_type,func_cheap,varargin)
            
            p = inputParser;
            p.KeepUnmatched = true;
            p.PartialMatching = false;
            p.addRequired('func_cheap',@(x)validateattributes(x,{'function_handle','char'},{'nonempty'}));
            p.parse(func_cheap)
            in = p.Results;
            
            % Superclass constructor
            obj@Expected_improvement(prob,y_ind,g_ind,meta_type,varargin{:});
            
            obj.func_cheap = in.func_cheap;   
                        
        end
        
        [ EI_val] = EI_unconstrained( obj, x_test )
        [ EI_val, cons ] = EI_constrained( obj, x_test )
        [] = Opt_crit( obj )
        
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


