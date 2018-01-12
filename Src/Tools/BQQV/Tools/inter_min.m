function d_min = inter_min ( x, k ,r, d )
    % INTER_MIN computes the opposite of the minimum inter-point distance
    % for the set of k points x in spheric coordinates on the the
    % hypersphere of radius r in dimension d.
    % 
    %   Inputs:
    %       x set of points in spheric coordinates
    %       r radius of the hypersphere
    %       k number of points in the set
    %       d the dimension of the problem
    %
    %   Output:
    %       d_min the opposite of the minimum inter-point distance for the set
    %
    % Syntax:
    %   d_min = inter_min ( x, k ,r, d );
    
    x = reshape(x',k,d-1);
    x = hypersph2cart( [r*ones(1,k); x'] )';
    temp = ipdm(x);
    d_min = -min( temp(logical(tril(ones(k),-1))) );

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


