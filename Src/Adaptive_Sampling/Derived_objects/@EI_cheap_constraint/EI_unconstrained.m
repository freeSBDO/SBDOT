function [ EI_val ] = EI_unconstrained( obj, x_test )
%EI_UNCONSTRAINED
% Compute the Expected Improvement value for unconstrained case at x_test

cheap_cons = feval( obj.func_cheap, x_test ); 

% Prediction value and error at test point
if isequal(obj.meta_type,@Q_kriging)
    n_test = size(x_test,1);
    [ y_pred, MSE_pred ] = obj.meta_y.Predict( x_test,repmat(obj.QV_val,n_test,1) );
else
    [ y_pred, MSE_pred ] = obj.meta_y.Predict( x_test );
end
EI_val = -stk_sampcrit_ei_eval(y_pred, sqrt(abs( MSE_pred )), obj.y_min);
% Cheap constraint
EI_val( any( cheap_cons > 0, 2 ) , : ) = nan( size( sum( any(cheap_cons<0,2) , 1 ) ) );
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


