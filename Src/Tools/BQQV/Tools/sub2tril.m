function ind = sub2tril(sub, n)
    % SUB2TRIL has the same function as sub2indVect execpt that it works
    % with triangular matrices
    % 
    %   Inputs:
    %       sub is the subscript
    %       n is the number of rows (i.e. columns since matrices are squares)
    %
    %   Output:
    %       ind is the index consistent to the indexing of a triangular matrix
    %
    % Syntax:
    %   ind = sub2tril( sub, n );
    
    ind = n*(n+1)/2-(n-sub(:,2)).*(n-sub(:,2)+1)/2-(n-sub(:,1));
    
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


