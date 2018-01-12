function f = Q_sin_cos(x)
    %Q_sin_cos
    % x is a ... by 6 matrix of input points
    %   variable 1 and 2 (in column 1 and 2) are quantitative; set between [0 1] or [-1 1] usually
    %	variable 3 and 5 (in column 3 and 5) are qualitative; frequencies
    %	variable 4 and 6 (in column 4 and 6) are qualitative; amplitudes
    %
    % f is a ... by 1 matrix of objective values
    %   Q_sin_cos has 1 objective function
    
    x1 = x(:,1);
    x2 = x(:,2);
    Freq1 = x(:,3);
    Amp1 = x(:,4);
    Freq2 = x(:,5);
    Amp2 = x(:,6);

    f = Amp1.*sin(pi*Freq1.*x1) + Amp2.*cos(pi*Freq2.*x2);
    
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


