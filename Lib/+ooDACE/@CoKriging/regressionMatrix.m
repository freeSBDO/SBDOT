%> @file "@CoKriging/regressionMatrix.m"
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

	% cokriging implementation
    if exist( 'points', 'var' )
        if nargout > 1
            [F, dF] = this.regressionMatrix@ooDACE.BasicGaussianProcess( points );
            dF = [this.rho{1}.*dF dF];
        else
            F = this.regressionMatrix@ooDACE.BasicGaussianProcess( points );
        end
        
        F = [this.rho{1}.*F F];
    else
        F1 = this.GP{1}.getRegressionMatrix();
        F2 = this.GP{2}.getRegressionMatrix();
        F = [F1 zeros(size(F1,1),size(F2,2)) ; (this.rho{1}.*F2) F2];
        
        % derivatives to hp
        % not supported (not needed either)
        if nargout > 1
            error( 'CoKriging:regressionMatrix: Hyperparameter derivatives not supported for co-kriging' );
        end
    end
end
