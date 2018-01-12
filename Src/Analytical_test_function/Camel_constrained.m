function [ y, g ] = Camel_constrained( x )
% CAMEL_CONSTRAINED 
%   for constrained optimization benchmark
% lb = [-2 -2]; ub = [2 2]

y = (4 - 2.1 *( x(:,1).^2 ) + ( x(:,1).^4 )/3) .* ( x(:,1).^2 ) ...
    + x(:,1) .* x(:,2) ...
    + (-4 + 4.*( x(:,2).^2 )).*( x(:,2).^2 );

g = 1.5 - (1.5*x(:,2) - cos(31*x(:,2))/6).^2 - x(:,1);

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


