function f = test_multi_obj(x)
    %test_multi_obj
    % x is a ... by 3 matrix of input points
    %   variable 1 and 2 (in column 1 and 2) are quantitative; set between ]0 1[
    %	variable 3 (in column 3) is qualitative; index
    %
    % f is a ... by 1 matrix of objective values
    %   f has 1 objective function
    
    x1 = x(:,1);
    x2 = x(:,2);
    q = x(:,3);

    ind = cell2mat(arrayfun(@(i) q == i, 1:6, 'UniformOutput', false));
    
    f = zeros(size(x,1),1);
    f(ind(:,1)) = 0.5.*sin(pi.*1.3.*x1(ind(:,1))) + 0.7.*cos(pi.*1.5.*x2(ind(:,1)));
    f(ind(:,2)) = 0.5.*sin(pi.*1.3.*x1(ind(:,2))) + cos(pi.*1.5.*x2(ind(:,2)));
    f(ind(:,3)) = 0.7.*sin(pi.*2.3.*x1(ind(:,3))) + 0.7.*cos(pi.*0.7.*x2(ind(:,3)));
    f(ind(:,4)) = 0.7.*sin(pi.*1.5.*x1(ind(:,4))) + 0.7.*cos(pi.*1.9.*x2(ind(:,4)));
    f(ind(:,5)) = sin(pi.*1.75.*x1(ind(:,5))) + 0.7.*cos(pi.*2.7.*x2(ind(:,5)));
    f(ind(:,6)) = sin(pi.*1.3.*x1(ind(:,6))) + cos(pi.*1.5.*x2(ind(:,6)));
    
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


