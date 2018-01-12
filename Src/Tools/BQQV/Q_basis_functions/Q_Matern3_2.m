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



% ==========================================================================
%
%    This file is part of SBDOT.
%
%    SBDOT is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    SBDOT is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with SBDOT.  If not, see <http://www.gnu.org/licenses/>.
%
%    Use of SBDOT is free for personal, non-profit, pure academic research
%    and educational purposes. Restrictions apply on commercial or funded
%    research use. Please read the IMPORTANT_LICENCE_NOTICE file.
%
% ==========================================================================


