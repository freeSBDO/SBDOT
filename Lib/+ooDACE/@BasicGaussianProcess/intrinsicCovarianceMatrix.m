%> @file "@BasicGaussianProcess/intrinsicCovarianceMatrix.m"
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
%>	[Sigma dSigma] = intrinsicCovarianceMatrix(this, points1, points2 )
%
% ======================================================================
%> Generate covariance matrix matrix of points1 vs points2 using the current hyperparameters as followed:
%> - intrinsicCovarianceMatrix(this)
%>   - Assume points1 = points2 = samples
%> - intrinsicCovarianceMatrix(this, points1)
%>   - Not used (and not implemented yet)
%> - intrinsicCovarianceMatrix(this, points1, points2)
%>   - Not used (and not implemented yet)
% ======================================================================
function [Sigma, dSigma] = intrinsicCovarianceMatrix(this, points1, points2 )

    if exist( 'points1', 'var' )
        %% Full general case: psi( points1, points2 )
        % not used
        error( 'BasicGaussianProcess:intrinsicCovarianceMatrix: BUG: this shouldn''t happen' );
    else
      %% Specific case: sparse psi( this.samples, this.samples );
      % used
      % - for fitting (likelihood + updateModel)

      if this.optimIdx(:,this.LAMBDA)
        n = size(this.values, 1);
        o = (1:n)';

        lambda = 10.^this.tau2(ones(n,1),1);
        Sigma = sparse( o, o, lambda);

        % derivatives w.r.t. lambda
        if nargout > 1
            dSigma = cell(1,1);
            dSigma{1} = sparse( o, o, (lambda.*log(10) ./ 2) );
        end
      else
        % intrinsic covariance matrix is predefined/precalculated
        % This is the case for stochastic kriging and cross validation runs
        Sigma = this.getSigma();

        % never need derivatives as it isn't included in optimization
        dSigma = [];
      end

    end
end
