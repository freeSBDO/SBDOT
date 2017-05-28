%> @file "@CoKriging/extrinsicCorrelationMatrix.m"
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
%>	[psi dpsi] = extrinsicCorrelationMatrix(this, points1, points2)
%
% ======================================================================
%> Generate correlation matrix of points1 vs points2 using the current hyperparameters as followed:
%> - extrinsicCorrelationMatrix(this)
%>   - Assume points1 = points2 = samples
%> - extrinsicCorrelationMatrix(this, points1)
%>   - Assume points2 = samples
%> - extrinsicCorrelationMatrix(this, points1, points2)
%>
%> NOTE: The first case returns derivatives w.r.t. X
%> The latter two cases returns derivatives w.r.t. the hyperparameters
%>
%> Issues:
%> - Actually returns a covariance matrix instead of a correlation matrix
%> shouldn't be a problem as long as an extrinsicCorrelationMatrix method doesn't mix both types...
% ======================================================================
function [psi, dpsi] = extrinsicCorrelationMatrix(this, points1, points2)

    rho = this.rho{1};
    sigma21 = this.GP{1}.getProcessVariance();
    sigma22 = this.GP{2}.getProcessVariance();

    [samples1] = this.getSamplesIdx(1);
    [samples2] = this.getSamplesIdx(2);

    if exist( 'points1', 'var' )

        
        %% Full general case: psi( points1, points2 )
        % psi: correlation matrix
        % dpsi: derivative of psi w.r.t. X!
        % used
        % - for prediction
        if exist( 'points2', 'var' )
            error( 'CoKriging:extrinsicCorrelationMatrix: second parameter (points2) not supported for co-kriging.' );
        %else
            %points2 are the samples. but for cokriging this is a special case
        end

        if nargout > 1
            [t1, dt1] = this.GP{1}.extrinsicCorrelationMatrix( points1 ); % (x, samples1)
            [t2, dt2] = this.GP{1}.extrinsicCorrelationMatrix( points1, samples2 ); % (x, samples2)
            [t3, dt3] = this.GP{2}.extrinsicCorrelationMatrix( points1 ); % (x, samples2)
            
            dpsi = [(rho.*sigma21.*dt1) ; (rho.*rho.*sigma21.*dt2 + sigma22.*dt3)];
        else
            t1 = this.GP{1}.extrinsicCorrelationMatrix( points1 ); % (x, samples1)
            t2 = this.GP{1}.extrinsicCorrelationMatrix( points1, samples2 ); % (x, samples2)
            t3 = this.GP{2}.extrinsicCorrelationMatrix( points1 ); % (x, samples2)
        end
    
        psi = [(rho.*sigma21.*t1) (rho.*rho.*sigma21.*t2 + sigma22.*t3)];
    else
        %% Specific case: sparse psi( this.samples, this.samples );
        % psi: concatenated correlation matrices
        % dpsi: derivative of psi w.r.t. hyperparameters!
        % used
        % - for fitting
      
        % concatenate submatrices into one correlation matrix
        psi_11 = this.GP{1}.extrinsicCorrelationMatrix(); % this.GP{1}.getCovarianceMatrix()
        psi_12 = this.GP{1}.extrinsicCorrelationMatrix( samples1, samples2 );
        psi_22 = this.GP{1}.extrinsicCorrelationMatrix( samples2, samples2 );
        psi_22_2 = this.GP{2}.extrinsicCorrelationMatrix(); % this.GP{2}.getCovarianceMatrix()

        % Create sparse correlation matrix
        psi = [sigma21.*psi_11 ...
            rho.*sigma21.*psi_12 ; ...
            zeros(this.nrSamples(2,:),this.nrSamples(1,:)) ...
          rho.*rho.*sigma21.*psi_22 + sigma22.*psi_22_2];
        psi = sparse(psi);

        % derivatives to hp
        % not supported (not needed either)
        if nargout > 1
            error( 'CoKriging:extrinsicCorrelationMatrix: Hyperparameter derivatives not supported for co-kriging' );
        end
    end
end
