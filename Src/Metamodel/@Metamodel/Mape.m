function [ stat ] = Mape( obj, x, y )
% MAPE 
% Compute the Mean Absolute Percentage Error (%) for (x,y)
%   *x is a n_eval by m_x matrix
%   *y is the output evaluated at x, n_eval by 1 matrix
%
% Syntax
%   stat=obj.mape(x,y)

stat = 100 * mean( abs( ( y - obj.Predict(x) ) ./ y) );

end

