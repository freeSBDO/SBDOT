function [] = Output_assert( obj, y_eval, g_eval )
    %OUTPUT_ASSERT Check outputs after evaluation
    %   *y_eval is the matrix of output values to assert
    %
    % Syntax :
    % obj.Output_assert( y_eval );
    
    assert( size(y_eval,2) == obj.m_y, ...
        'SBDOT:Problem:dimension_output', ...
        ['The number of objectives m_y that you set is not ', ...
        'the one obtained after evaluation of the function'] )

    if ~isempty( g_eval )

        assert( size(g_eval,2) == obj.m_g, ...
            'SBDOT:Problem:dimension_constraint', ...
            ['The number of constraints m_g that you set is not ', ...
            'the one obtained after evaluation of the function'] )

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


