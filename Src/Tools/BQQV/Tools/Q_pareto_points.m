function [y_pareto,pareto_index] = Q_pareto_points( Q_krig )
%% Q_pareto_points : select pareto optimal first front objectives values and their indices
%   Q_krig : Q_kriging class object containing the points on which the
%   pareto front is computed
%
%   y_pareto are the pareto optimal points (objectives values) that are in
%   the admissible space (constraints fullfiled)
%
%   pareto_index are the index of the pareto optimal points in y

    x_pareto = cell2mat(Q_krig.prob.x');
    ind = cumsum(Q_krig.prob.n_x);
    ind = [ [1,ind(1:(end-1))+1]; ind ];
    y_pareto_temp = zeros(sum(Q_krig.prob.n_x),prod(Q_krig.prob.m_t));

    for i = 1 : prod(Q_krig.prob.m_t)

        x_temp = x_pareto(ind(1,i):ind(2,i),1:Q_krig.prob.m_x);
        y_pareto_temp(ind(1,i):ind(2,i),i) = Q_krig.prob.y{i};
        mod = 1:prod(Q_krig.prob.m_t);
        mod(mod==i) = [];
        q_val = cell2mat(arrayfun(@(k) repmat(k,size(x_temp,1),1), mod, 'UniformOutput', false)');
        y_temp = Q_krig.Predict( repmat(x_temp, length(mod), 1), q_val);
        y_pareto_temp(ind(1,i):ind(2,i),mod) = reshape(y_temp,[Q_krig.prob.n_x(i),length(mod)]);

    end

    [y_pareto,pareto_index] = Pareto_points(y_pareto_temp);

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


