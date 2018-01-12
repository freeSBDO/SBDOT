function [ EI_val, cons ] = EI_constrained( obj, x_test )
% EI_CONSTRAINED
%   Detailed explanation goes here
% Compute the Expected Improvement (EI1) 
% and the Probability of feasibility (EI2) value
% for constrained case at x_test

% Prediction value and error at test point
if isequal(obj.meta_type,@Q_kriging)
    n_test = size(x_test,1);
    [ y_pred, MSE_pred ] = obj.meta_y.Predict( x_test,repmat(obj.QV_val,n_test,1) );
    
    for i = 1 : obj.m_g
        [g_pred(:,i), MSE_g_pred(:,i) ] = obj.meta_g(i,:).Predict(x_test,repmat(obj.QV_val,n_test,1));
    end
else
    
    [ y_pred, MSE_pred ] = obj.meta_y.Predict( x_test );
    
    for i = 1 : obj.m_g
        [g_pred(:,i), MSE_g_pred(:,i) ] = obj.meta_g(i,:).Predict(x_test);
    end
end

EI1 = stk_sampcrit_ei_eval(y_pred, sqrt(abs( MSE_pred )), obj.y_min);

EI2 = stk_distrib_normal_cdf ( 0 , g_pred , sqrt(abs( MSE_g_pred )));
EI2 = prod( EI2, 2);


EI_val = [-EI1, -EI2];
% cheap constraint
cons = feval( obj.func_cheap, x_test ); 

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


