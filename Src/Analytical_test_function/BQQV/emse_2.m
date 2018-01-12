function y = emse_2(x)
    %emse_2
    % x is a ... by 2 matrix of input points
    %   variable 1 (in column 1) is set between [0 1] or [-1 1] usually
    %	variable 2 (in column 2) is qualitative; levels : [1, 2, 3]
    %
    % y is a ... by 1 matrix of objective values
    %   emse_2 has 1 objective function
    %   objective 1 (in column 1) is the objective function from Esperan Padonou
    
    q=x(:,2);
    x=x(:,1);
    y = (-2.5+4.75*q-1.25*q.^2).*(-1).^(q-1).*cos(pi*(7-0.2*round(0.9./q)).*x/2);
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


