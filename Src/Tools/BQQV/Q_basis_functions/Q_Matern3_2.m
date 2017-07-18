function [ corr, dx ] = Q_Matern3_2(theta, d, tau, m_t)
    % Q_MATERN3_2 is the matern 3/2 kernel (definite-positive function)
    %
    %   Inputs:
    %       theta are the correlation lengths
    %       d manhattan distances between pooints of interest
    %       tau are the coefficients corresponding to the levels of points
    %       m_t contains the number of levels for each modality combination
    %
    %   Output:
    %       corr is the vector corresponding to the lower-half of the symmetric correlation matrix
    %       dx is the matrix of derivatives concerning quantitative variables
    %
    % Syntax :
    %   [ corr, dx ] = Q_Matern3_2(theta, d, tau, m_t);
    
    theta = 10.^theta(:).';
    [l, m] = size(d);
    inner = sum(bsxfun( @times, abs(d).^2, theta),2);
    corr = tau.*((1+sqrt(3*inner))).*exp(-sqrt(3*inner));

    if nargout > 1
        
        inner( inner == 0 ) = eps;
        t = sqrt(3*inner);
        right = exp( -t );
        f = tau.*(1 + t);
        df = tau;
        dtx = sqrt(3) .* d .* theta(ones(l,1),:) ./ sqrt(inner(:,ones(1,m)));
        dx = (df - f(:,ones(1,m))) .* dtx .* right(:,ones(1,m));
        
    end
    
end