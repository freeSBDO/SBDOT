function [ stat ] = Raae( x, y )
    % RAAE Compute the Relative Average Absolute Error for (x,y)
    %   *x is a n_eval by m_x matrix
    %   *y is the output evaluated at x, n_eval by 1 matrix
    %
    % Syntax
    %   stat=obj.raae(x,y)
    
    stat = mean( abs( y - obj.Predict(x) ) ) / std(y);
    
end

