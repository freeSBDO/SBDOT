function [ stat ] = Nmse( obj, x, y )
% NMSE Compute the Normalized Mean Square Error (%) for (x,y)
%   *x is a n_eval by m_x matrix
%   *y is the output evaluated at x, n_eval by 1 matrix
%
% Syntax
%   stat=obj.nmse(x,y)

stat = 100 * sum( (y - obj.Predict(x)).^2 ) / sum( (y - mean(y)).^2 );

end

