function y_LF = Multifi_1D_LF( x )
% Test function for multifidelity: low fidelity
%
% x is a ... by 1 matrix of input points
%   variable 1 (in column 1) is set between [0 1]
%
% y_LF is a ... by 1 matrix of low fidelity objective values
%
% Ref: A. Forrester, D. A. Sobester, and A. Keane, Engineering Design via
% Surrogate Modelling: A Practical Guide. John Wiley & Sons, 2008. (p. 173)


A = 0.5;
B = 10;
C = 5;

ye_c = (( 6*x - 2 ).^2) .* sin( 12*x - 4 );
y_LF = A*ye_c + B*( x - 0.5 ) - C;

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


