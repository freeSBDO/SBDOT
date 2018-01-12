function n_eval = Input_assert( obj, x_eval )
    %INPUT_ASSERT Check inputs before evaluation
    %   *x_eval is the matrix of input points to assert
    %
    % Syntax :
    % n_eval = obj.Input_assert( x_eval );

    [ n_eval, m_eval ] = size( x_eval );

    assert( m_eval == obj.m_x, ...
        'SBDOT:Problem:dimension_input', ...
        ['The dimension of your evaluation points is not equal to ', ...
        num2str( obj.m_x ), ', check input matrix number of columns.']);

    assert( any( all( bsxfun( @ge, x_eval, obj.lb), 2 ) ...
                 & ...
                 all( bsxfun( @le, x_eval, obj.ub), 2 ) ...
                ), ...
        'SBDOT:Problem:eval_bound',...
        'At least one of your evaluation points is out of bounds.');

    assert( size( unique( x_eval, 'rows' ), 1 ) == n_eval, ...
        'SBDOT:Problem:eval_notunique', ...
        'You are trying to evaluate the same points multiple times.');

    if ~isempty( obj.x )

        assert( all ( ~ismembertol( obj.x, x_eval, obj.tol_eval, 'Byrows', true) ), ...
            'SBDOT:Problem:already_eval', ...
            'At least one of your evaluation points is too closed from training dataset points.');

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


