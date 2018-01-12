function [ obj_val ] = Optim_env( obj, x_env, x_new_rob )
% OPTIM_ENV
%   Objective function for selection of environmental parameters values before evaluation
%   The point with the maximum prediction error is selected
%   
%   * x_env are the environmental values to try
%   * x_new_rob is the optimum of EI criterion obtained previously in Opt_crit
%

nbr_points = size(x_env,1);

x_eval = [ repmat( x_new_rob, nbr_points, 1) x_env ];

if isequal(obj.meta_type,@Q_kriging)
    [ ~, mse_y_pred ] = obj.meta_y.Predict( x_eval,repmat(obj.QV_val,nbr_points,1) );
else
    [ ~, mse_y_pred ] = obj.meta_y.Predict( x_eval );
end

if obj.m_g>0
    for i=1:obj.m_g
        if isequal(obj.meta_type,@Q_kriging)
            [ ~, mse_g_pred(:,i) ] = obj.meta_g(i,:).Predict( x_eval,repmat(obj.QV_val,nbr_points,1) );
        else
            [ ~, mse_g_pred(:,i) ] = obj.meta_g(i,:).Predict( x_eval );
        end 
    end
    obj_val = -max( [mse_y_pred mse_g_pred], [], 2 );
else
    obj_val = -mse_y_pred;
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


