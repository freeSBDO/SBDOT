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

