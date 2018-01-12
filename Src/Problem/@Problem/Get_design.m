function [] = Get_design( obj, num_x, type )
    % GET_DESIGN Create a sampling plan and evaluates it
    %   *num_x is the number of sampling points to create
    %   *type is the type of the sampling. Allowed list :
    %   ['LHS'], 'OLHS', 'Sobol', 'Halton'.
    %
    % Syntax :
    % obj.Get_design( num_x );
    % obj.Get_design( num_x, type );
    
    if nargin <= 2
        type = 'LHS';
    end
    
    % Sampling
    x_sampling = obj.Sampling( num_x, type );
    
    % Evaluation
    obj.Eval( x_sampling );

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


