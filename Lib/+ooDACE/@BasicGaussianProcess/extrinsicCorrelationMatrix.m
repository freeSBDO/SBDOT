%> @file "@BasicGaussianProcess/extrinsicCorrelationMatrix.m"
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
%>	[psi dpsi] = extrinsicCorrelationMatrix(this, points1, points2 )
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
% ======================================================================
function [psi, dpsi] = extrinsicCorrelationMatrix(this, points1, points2 )

    if exist( 'points1', 'var' );
        
        %% Full general case: psi( points1, points2 )
        % psi: correlation matrix
        % dpsi: derivative of psi w.r.t. X!
        % used
        % - for prediction
        % - by cokriging to calculate submatrices
        
        if ~exist( 'points2', 'var' )
            points2 = this.samples(this.P(1:this.rank),:); % NOTE: is this the right place to apply the permutation ?
        end
        
        % modif_cdu, nd :
        [n1, nd] = size(points1);
        n2 = size(points2, 1);
        
        % modif_cdu :
        %dist = points1(nPoints1(ones(n2,1),:)',:) - points2(nPoints2(ones(n1,1),:),:);
        dist = reshape(bsxfun(@minus,permute(points1,[1 3 2]),permute(points2,[3 1 2])),n1*n2,nd);
        
        if nargout > 1
             [psi, dpsi] = feval(this.correlationFcn, this.getHyperparameters(), dist);
        else
            psi = feval(this.correlationFcn, this.getHyperparameters(), dist);
        end
        psi = reshape(psi, n1, n2);
    else
    
      %% Specific case: sparse psi( this.samples, this.samples );
      % psi: correlation matrix
      % dpsi: derivative of psi w.r.t. hyperparameters!
      % used
      % - for fitting (likelihood + updateModel)
      % - by cokriging to calculate submatrices
      
      n = size(this.values, 1);
      o = (1:n)';

      % Fast calculation of correlation matrix
      if nargout > 1
        [psi, ~, dhp] = feval(this.correlationFcn, this.getHyperparameters(), this.dist);

        dpsi = cell(1,size(dhp,2));
        for i=1:length(dpsi)
            idx = find(dhp(:,i) ~= 0);
            dpsi{i} = full(sparse([this.distIdxPsi(idx,1); o], [this.distIdxPsi(idx,2); o], [dhp(idx,i); zeros(n,1)]));
        end
      else
        psi = this.correlationFcn( this.getHyperparameters(), this.dist );
      end

      % Create sparse correlation matrix
      idx = find(psi > 0);
      % modif_cdu, full :
      psi = full(sparse([this.distIdxPsi(idx,1); o], [this.distIdxPsi(idx,2); o], [psi(idx); ones(n,1)]));
    end
end
