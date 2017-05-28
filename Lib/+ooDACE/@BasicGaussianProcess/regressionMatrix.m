%> @file "@BasicGaussianProcess/regressionMatrix.m"
%> @authors Ivo Couckuyt
%> @version 1.4 ($Revision$)
%> @date $LastChangedDate$
%> @date Copyright 2010-2013
%>
%> This file is part of the ooDACE toolbox
%> and you can redistribute it and/or modify it under the terms of the
%> GNU Affero General Public License version 3 as published by the
%> Free Software Foundation.  With the additional provision that a commercial
%> license must be purchased if the ooDACE toolbox is used, modified, or extended
%> in a commercial setting. For details see the included LICENSE.txt file.
%> When referring to the ooDACE toolbox please make reference to the corresponding
%> publications:
%>   - Blind Kriging: Implementation and performance analysis
%>     I. Couckuyt, A. Forrester, D. Gorissen, F. De Turck, T. Dhaene,
%>     Advances in Engineering Software,
%>     Vol. 49, pp. 1-13, July 2012.
%>   - Surrogate-based infill optimization applied to electromagnetic problems
%>     I. Couckuyt, F. Declercq, T. Dhaene, H. Rogier, L. Knockaert,
%>     International Journal of RF and Microwave Computer-Aided Engineering (RFMiCAE),
%>     Special Issue on Advances in Design Optimization of Microwave/RF Circuits and Systems,
%>     Vol. 20, No. 5, pp. 492-501, September 2010. 
%>
%> Contact : ivo.couckuyt@ugent.be - http://sumo.intec.ugent.be/?q=ooDACE
%> Signature
%>	[F dF] = regressionMatrix(this, points)
%
% ======================================================================
%> Regression matrix (model matrix, Vandermonde matrix, ...) for a set of points
%> Based on this.regressionFcn
% ======================================================================
function [F, dF] = regressionMatrix(this, points)

    [n, dim] = size(points);

	% standard implementation
    F = ooDACE.tools.buildVandermondeMatrix( points, this.regressionFcn, ooDACE.tools.cfix( @ooDACE.tools.powerBase, dim ) );
    
    % the (pseudo) derivative of F
    % limited to one point at a time
    % returns dF with the rows being the derivative of each dimension and
    % the columns the actual terms of the derived function multiplied by
    % their coefficient.
    if nargout > 1
        assert( n == 1, 'Derivative of the regression matrix supports only one point at a time.' );
        
        dF = zeros(dim,size(this.regressionFcn,1));
        for i=1:dim
            % derive i'th variable
            dRegressionFcn = this.regressionFcn;
            dRegressionFcn(:,i) = max( dRegressionFcn(:,i) - 1, 0 );
            
            dF(i,:) = ooDACE.tools.buildVandermondeMatrix( points, dRegressionFcn, ooDACE.tools.cfix( @ooDACE.tools.powerBase, dim ) );
            
            % multiply by their powers (if power == 0 then result is zero as expected)
            dF(i,:) = dF(i,:) .* this.regressionFcn(:,i).';
        end
    end
end
