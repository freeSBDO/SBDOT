function f = test_multi_obj_ind(x)
%test_multi_obj
% x is a ... by 3 matrix of input points
%   variable 1 and 2 (in column 1 and 2) are quantitative; set between ]0 1[
%
% f is a ... by 6 matrix of objective values
%   f has 6 objective function

x1 = x(:,1);
x2 = x(:,2);


f = zeros(size(x,1),6);
f(:,1) = 0.5.*sin(pi.*1.3.*x1) + 0.7.*cos(pi.*1.5.*x2);
f(:,2) = 0.5.*sin(pi.*1.3.*x1) + cos(pi.*1.5.*x2);
f(:,3) = 0.7.*sin(pi.*2.3.*x1) + 0.7.*cos(pi.*0.7.*x2);
f(:,4) = 0.7.*sin(pi.*1.5.*x1) + 0.7.*cos(pi.*1.9.*x2);
f(:,5) = sin(pi.*1.75.*x1) + 0.7.*cos(pi.*2.7.*x2);
f(:,6) = sin(pi.*1.3.*x1) + cos(pi.*1.5.*x2);

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


