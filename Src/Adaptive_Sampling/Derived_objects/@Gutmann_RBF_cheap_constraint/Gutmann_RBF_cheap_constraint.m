classdef Gutmann_RBF_cheap_constraint < Gutmann_RBF
    % GUTMANN_RBF_CHEAP_CONSTRAINT 
    % Gutmann optimization algorithm with RBF
    % Single objective RBF based optimization method.
    % When cheap to call constraint function is available
    % 
    % obj = Gutmann_RBF(prob, y_ind, g_ind, meta_type, func_cheap, feas_point, varargin)
    %    
    % Mandatory inputs :
    %   * see Gutmann_RBF help
    %   - func_cheap is a string or function handle of numerical model to call for 
    %   cheap constraint evaluation.
    %   - feas_point is a feasible point regarding the cheap constraint in
    %   order to have a good starting point for the optimization
    %
    % Optional inputs [default value]:
    %   * see Gutmann_RBF help
    %
    properties
        
        func_cheap % String or function handle of cheap constraint model
        feas_point % Good starting point for optimization in feasible area
        
    end
    
    methods
        
        function obj = Gutmann_RBF_cheap_constraint(prob,y_ind,g_ind,meta_type,func_cheap,feas_point,varargin)
            
            p = inputParser;
            p.KeepUnmatched = true;
            p.PartialMatching = false;
            p.addRequired('func_cheap',@(x)validateattributes(x,{'function_handle','char'},{'nonempty'}));
            p.addRequired('feas_point',@(x)isnumeric(x));
            p.parse(func_cheap,feas_point)
            in = p.Results;
            
            % Superclass constructor
            obj@Gutmann_RBF(prob,y_ind,g_ind,meta_type,varargin{:});
            
            obj.func_cheap = in.func_cheap;   
            obj.feas_point = in.feas_point; 
                        
        end
        
        [ crit ] = Gutmann_crit( obj, x ,min_target )
        [ y_pred ] = Obj_predict( obj, x )
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


