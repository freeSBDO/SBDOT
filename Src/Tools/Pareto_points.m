function [ y_pareto, pareto_index ] = Pareto_points( y, g )
%% pareto_points : select pareto optimal first front objectives values and their indices
%   y : (n by m2 matrix) is the output vector of the dataset
%   => n is the number of points
%   => m2 is the number of objectives
%
%   g (optional) : (n by mg matrix) is the output vector of the dataset
%   => n is the number of points
%   => mg is the number of contraints
%
%   y_pareto are the pareto optimal points (objectives values) that are in
%   the admissible space (constraints fullfiled)
%
%   pareto_index are the index of the pareto optimal points in y

y_comparaison = permute( y, [3 2 1] );

domination(:,:) = permute( all( bsxfun(@lt,y,y_comparaison), 2 )...
    & any( bsxfun(@lt,y,y_comparaison), 2 ) ,...
    [1 3 2]);

if nargin == 2
    
    pareto_index = (sum(domination,1)') + (~all(g<=0,2)) ==0;
    
else
    
    pareto_index = sum(domination,1)' == 0;
    
end

y_pareto = y(pareto_index,:);

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


