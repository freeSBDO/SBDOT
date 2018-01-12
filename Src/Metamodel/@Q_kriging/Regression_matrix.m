function [F, dF] = Regression_matrix( obj, points )
    % REGRESSION_MATRIX Does the regression part of the fit during Fit
    % method for Q_kriging objects
    %
    %   Inputs:
    %       obj is an object of class Q_kriging
    %       points are the sample values in the DoE
    %
    %   Output:
    %       F is the vandermonde matrix of the regression
    %       dF is F derivative
    %
    % Syntax :
    % [F, dF] = obj.Regression-matrix( points );
    
    [n, dim] = size(points);

	% standard implementation
    F = ooDACE.tools.buildVandermondeMatrix( points, obj.regpoly, ooDACE.tools.cfix( @ooDACE.tools.powerBase, dim ) );
    
    % the (pseudo) derivative of F
    % limited to one point at a time
    % returns dF with the rows being the derivative of each dimension and
    % the columns the actual terms of the derived function multiplied by
    % their coefficient.
    if nargout > 1
        assert( n == 1, 'Derivative of the regression matrix supports only one point at a time.' );
        
        dF = zeros(obj.prob.m_x,size(obj.regpoly,1));
        for i=1:obj.prob.m_x
            % derive i'th variable
            dRegressionFcn = obj.regpoly;
            dRegressionFcn(:,i) = max( dRegressionFcn(:,i) - 1, 0 );
            
            dF(i,:) = ooDACE.tools.buildVandermondeMatrix( points, dRegressionFcn, ooDACE.tools.cfix( @ooDACE.tools.powerBase, dim ) );
            
            % multiply by their powers (if power == 0 then result is zero as expected)
            dF(i,:) = dF(i,:) .* obj.regpoly(:,i).';
        end
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


