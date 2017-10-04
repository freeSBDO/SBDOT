function [ stat ] = Rmae( obj, x, y )
% RMAE 
%   Compute the Relative Maximum Absolute Error for (x,y)
%   *x is a n_eval by m_x matrix
%   *y is the output evaluated at x, n_eval by 1 matrix
%
% Syntax
%   stat=obj.rmae(x,y)

stat = max ( abs( y - obj.Predict(x) ) ) / std(y);

end

