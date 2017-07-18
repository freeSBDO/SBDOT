function [ corr, dx ] = Q_Gauss(theta, d, tau, ~)
    % Q_GAUSS is the gaussian kernel (definite-positive function)
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
    %   [ corr, dx ] = Q_Gauss(theta, d, tau, m_t);
    
    theta = 10.^theta(:).';
    [l, m] = size(d);
    inner = bsxfun( @times, -abs(d).^2, theta);
    corr = tau.*exp(sum(inner, 2));
    
    if  nargout > 1
        
      dx = -2 .* (theta(ones(l,1),:).^2) .* d .* corr(:,ones(1,m));
      
    end
    
end