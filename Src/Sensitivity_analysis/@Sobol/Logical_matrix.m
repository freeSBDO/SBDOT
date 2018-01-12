function M = Logical_matrix( obj )
% LOGICAL_MATRIX
% Build matrix M which each rows defines input variable indices
% linked to the current sobol partial indice computation
% Example : rows [0101] model indice S_2-4
% If m >= 10, only first order indices are computed 

if obj.m < 10 % 
    N = 2 ^ obj.m;
    M1 = zeros( N, obj.m);
    for k = 1 : obj.m
        v = [ zeros( 2^(k-1), 1 ) ; ones( 2^(k-1), 1 ) ];
        M1( : ,obj.m-k+ 1) = repmat( v, 2^(obj.m-k), 1);
    end
else
    % identity
    M1=[zeros(1,obj.m) ; eye(obj.m)];
end

M1( sum(M1,2) < 2, : ) = [];
M2 = eye( obj.m );
% First order indices will be computed first
M = [ M2 ; M1 ];

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


