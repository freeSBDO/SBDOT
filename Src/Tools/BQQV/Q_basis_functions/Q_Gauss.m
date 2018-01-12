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


