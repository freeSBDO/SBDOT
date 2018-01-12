function [ y_pred, power] = Predict( obj, x_eval )
% PREDICT
%   Predict the output value at new input points of HF model
%   - power is a measure of prediction error (from Gutmann)
%
%   Syntax examples :
%       y_pred=obj.Predict(x_eval);
%       [y_pred, power]=obj.Predict(x_eval);

switch nargout
    case {0,1} % y_pred
        
        y_pred = obj.rho*obj.RBF_c.Predict(x_eval) ...
            + obj.RBF_d.Predict(x_eval);
        
    case 2 % and power
        
        y_pred = obj.rho*obj.RBF_c.Predict(x_eval) ...
            + obj.RBF_d.Predict(x_eval);
        [~,power] = obj.RBF_d.Predict(x_eval);
        
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


