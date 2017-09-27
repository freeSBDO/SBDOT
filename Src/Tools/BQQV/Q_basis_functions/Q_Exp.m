function [ corr, dx ] = Q_Exp(theta, d, tau, ~)
    % Q_EXP is the exponential kernel (definite-positive function)
    %
    %   Inputs:
    %       theta are the correlation lengths
    %       d manhattan distances between pooints of interest
    %       tau are the coefficients corresponding to the levels of points
    %
    %   Output:
    %       corr is the vector corresponding to the lower-half of the symmetric correlation matrix
    %       dx is the matrix of derivatives concerning quantitative variables
    %
    % Syntax :
    %   [ corr, dx ] = Q_Exp(theta, d, tau, m_t);
    
    theta = 10.^theta(:).';
    [~, m] = size(d);
    inner = bsxfun( @times, -abs(d), theta);
    corr = tau.*exp(sum(inner, 2));
    
    if  nargout > 1
        
      dx = -theta .* sign(d) .* corr(:, ones(1,m));
      
    end
    
end