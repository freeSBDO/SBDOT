function [ stat ] = R2( obj, x, y )
    % r2 Compute the coefficient of determination for (x,y)
    %   *x is a n_eval by m_x matrix
    %   *y is the output evaluated at x, n_eval by 1 matrix
    %
    % Syntax
    %   stat=obj.r2(x,y)

    y_hat = obj.Predict(x);
    TSS = sum( (y - mean(y)) .^2 );
    RSS = sum( (y - y_hat).^2 );
    stat = 1 - (RSS/TSS);
    
end

