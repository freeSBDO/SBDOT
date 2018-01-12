function [ y_rob, mse_y_rob, g_rob, mse_g_rob ] = Eval_rob_meas( obj, x_test )
% EVAL_ROB_MEAS
%   Use the m_y objectives prediction to compute the robustness measure

nb_points = size(x_test,1);

for i = 1 : obj.m_y
    if isequal(obj.meta_type,@Q_kriging)
        n_test = size(x_test,1);
        [ y_pred(:,i), mse_y_pred(:,i) ] = obj.meta_y(i).Predict( x_test,repmat(obj.QV_val,n_test,1) );
    else
        [ y_pred(:,i), mse_y_pred(:,i) ] = obj.meta_y(i).Predict( x_test );
    end
end

mse_y_rob = obj.Worstcase_meas( mse_y_pred', nb_points );
y_rob = feval( obj.meas_type_y, obj, y_pred', nb_points );

if obj.m_g > 0
    
    for i = 1 : obj.m_g
        
        if isequal(obj.meta_type,@Q_kriging)
            [ g_pred(:,i), mse_g_pred(:,i) ] = obj.meta_g(i,:).Predict( x_test,repmat(obj.QV_val,n_test,1) );
        else
            [ g_pred(:,i), mse_g_pred(:,i) ] = obj.meta_g(i,:).Predict( x_test );
        end                
        
        if isequal( obj.meas_type_g, @Worstcase_meas )
            
            [ g_rob(:,i), id_meas ] = feval( obj.meas_type_g, obj, g_pred(:,i), nb_points );
            
            mse_reshape = reshape( mse_g_pred(:,i), obj.CRN_samples, nb_points );
            mse_g_rob(:,i) = diag( mse_reshape(id_meas, 1:nb_points) );
            
        else
            
            g_rob(:,i) = feval( obj.meas_type_g, obj, g_pred(:,i), nb_points );
            mse_g_rob(:,i) = obj.Worstcase_meas( mse_g_pred(:,i), nb_points );
            
        end
        
    end
    
else
    
    g_rob=[];
    mse_g_rob=[];
    
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


