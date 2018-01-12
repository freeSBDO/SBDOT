function out = Marginal_likelihood( obj )
    % MARGINAL_LIKELIHOOD computes the marginal likelihood
    %
    %   Inputs:
    %       obj is an object of class Q_kriging
    %
    %   Output:
    %       out returns the value of the marginal_likelihood
    %
    % Syntax :
    % out = obj.Marginal_likelihood);

    mat = cell2mat(obj.values');
    n = size( mat, 1 );
	
	% Negative of concentrated log-likelihood

    % Yt (and residual) is calculated twice (see updateRegression)
    Yt = obj.C \ mat;
    residual = Yt - obj.Ft * obj.alpha;
        
    % log( det(obj.C*obj.C') ) =
    lnDetPsi = 2.*sum(log(diag(obj.C)));
   
    if obj.optim_idx( 1, obj.SIGMA2 )
        
        % obj.C is covariance matrix instead of correlation matrix -> likelihood changes a bit
        % use the profile marginalized log-likelihood of Rasmussen 2006

        % profile marginalized log-likelihood
        out = 0.5 .* (sum(sum(residual.^2)) + lnDetPsi + n.*log(2.*pi)); % profile log-likelihood
        
    else
        
        % sigma2 is analytically optimized a priori
        % use concentrated log-likelihood
        
        out = 0.5 .* (n.*log(sum(obj.hyp_sigma2)) + lnDetPsi);
        
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


