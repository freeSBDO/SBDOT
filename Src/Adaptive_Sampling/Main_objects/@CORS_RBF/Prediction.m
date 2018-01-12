function [ y_pred ] = Prediction( obj, x )
% PREDICTION
% use for min_current search

y_pred = obj.meta_y.Predict(x);

constraint_distance_current(:,:) = sum(abs(bsxfun(@minus,permute(x,[3 2 1]),obj.prob.x)).^2,2);

constraint_distance = obj.beta_n * obj.delta_mm - max(min(constraint_distance_current,[],1));

y_pred( any(constraint_distance > 0, 2), : ) = nan( sum(any( constraint_distance > 0, 2 )), 1 );

if obj.m_g >= 1
    for i = 1 : obj.m_g
        g_pred(:,i) = obj.meta_g(i).Predict(x);
    end
    y_pred( any(g_pred > 0, 2), : ) = nan( sum(any( g_pred > 0, 2 )), 1 );
end

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


