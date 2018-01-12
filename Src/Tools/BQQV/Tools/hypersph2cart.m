function C = hypersph2cart(x)
    % HYPERSPH2CART converts hyperspheric coordinates to cartesian
    % coordinates
    %
    %   Inputs:
    %       x hypershperic coordinates
    %
    %   Output:
    %       C cartesian coordinates
    %
    % Syntax :
    % C = hypersph2cart( x );
    
    [d, n] = size(x);
    r = x(1,:);
    C = zeros(d,n);
    sph = x(2:d,:);
    premult = r;

    for i = 1:(d-1)
        
        C(i,:) = premult .* cos(sph(i,:));
        premult = premult .* sin(sph(i,:));
        
    end

    C(d,:) = premult;
    
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


