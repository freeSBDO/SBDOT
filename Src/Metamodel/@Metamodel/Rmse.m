function [ stat ] = rmse( x, y )
    % RMSE Compute the Root Mean Square Error for (x,y)
    %   *x is a n_eval by m_x matrix
    %   *y is the output evaluated at x, n_eval by 1 matrix
    %
    % Syntax
    %   stat=obj.rmse(x,y) 

    stat = sqrt( mean( (y - obj.predict(x)).^2 ) );

end

