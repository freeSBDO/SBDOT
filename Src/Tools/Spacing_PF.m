function S = Spacing_PF ( y )
%% spacing_PF : Uniformity measure of the pareto front
%   
%   y (n by m matrix) are the n current pareto points (m objective values)
%
%   S is the spacing metric (smaller is better)

D_min_i = pdist(y,'euclidean');
D_min_i = squareform( D_min_i );
D_min_i ( D_min_i == 0) = max(max(D_min_i));

D_min = min(D_min_i,[],2);

D_mean = mean(D_min);

S = sqrt((1/size(y,1))*sum((D_mean-D_min).^2));

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


