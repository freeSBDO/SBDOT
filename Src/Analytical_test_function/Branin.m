function [ y, g ] = Branin( x )
% Modified Branin test function
%
% x is a ... by 2 matrix of input points
%   variable 1 (in column 1) is set between [-5 10]
%	variable 2 (in column 2) is set between [0 15]
%
% y is a ... by 1 matrix of objective values
%   branin test has 1 objective function
%
% g is a ... by 1 matrix of constraint values
%   branin test has 1 constraint function
%
% Ref: A. Forrester, D. A. Sobester, and A. Keane, Engineering Design via
% Surrogate Modelling: A Practical Guide. John Wiley & Sons, 2008. (p. 196)

X1 = x(:,1);
X2 = x(:,2);

a = 1;
b = 5.1/(4*pi^2);
c = 5/pi;
d = 6;
e = 10;
ff = 1/(8*pi);

y = a .* ( X2 - b .* X1.^2 + c .* X1 - d ) .^ 2 + ...
    e .* ( 1 - ff ) .* cos( X1 ) +...
    e + ...
    5 .* ( ( X1 + 5 ) ./ 15 );

g = 0.2 - ( (( X1 + 5 ) ./ 15) .* (X2 ./15) );

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


