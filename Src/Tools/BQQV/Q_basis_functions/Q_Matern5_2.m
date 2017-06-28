function  corr = Q_Matern5_2(theta, d, tau, m_t)
    % Q_MATERN5_2 is the matern 5/2 kernel (definite-positive function)
    %
    %   Inputs:
    %       theta are the correlation lengths
    %       d manhattan distances between pooints of interest
    %       tau are the coefficients corresponding to the levels of points
    %       m_t contains the number of levels for each modality combination
    %
    %   Output:
    %       corr is the vector corresponding to the lower-half of the symmetric correlation matrix
    %
    % Syntax :
    %   corr = Q_Matern5_2(theta, d, tau, m_t);
    
    theta = 10.^theta(:).';
    n = prod(m_t);
    inner = sum(bsxfun( @times, abs(d).^2, theta),2);
    corr = tau.*((1+(5/3)*inner+sqrt(5*inner)).^n).*exp(-n*sqrt(5*inner));

end