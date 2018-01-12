function [] = Add_data( obj, x_add, y_add, g_add )
    %ADD_DATA Add input/output dataset to problem object
    %   x_add is the input matrix to add (n_x by m_x)
    %	y_add is the objective matrix to add (n_x by m_y)
    %	g_add is the constraint matrix to add (n_x by m_g)
    %
    % Syntax :
    % obj.add_rawDATA(x_add,y_add,g_add);
    % obj.add_rawDATA(x_add,y_add,[]); , if problem is unconstrained

    % Checks
    n_add = Input_assert( obj, x_add );
    obj.Output_assert( y_add, g_add);

    % Update object data
    obj.x = [ obj.x; x_add ];
    obj.y = [ obj.y; y_add ];
    obj.g = [ obj.g; g_add ];

    obj.n_x = size(obj.x,1);

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


