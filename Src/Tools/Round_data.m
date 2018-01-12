function [ x_round ] = Round_data( x, range )
    % ROUND_DATA Round input based on user scale
    %
    %   *x (n by m_x matrix) is the scaled input matrix of the dataset
    %   *range is a vector (1 by m_x) of value corresponding to the user precision needed.
    %
    % Syntax :
    % [x_round]=Round_data(x,range);
    % example x = 10.25487 , range = 0.001 ====> x_round = 10.255
    
    assert( size(range,2) == size(x,2),...
        'SBDOT:Round_data:round_range',...
        'round range size is not correct');

    x_round = bsxfun( @times, ...
        round( bsxfun( @times, x, ( 1./range ) ) ), ...
        range);

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


