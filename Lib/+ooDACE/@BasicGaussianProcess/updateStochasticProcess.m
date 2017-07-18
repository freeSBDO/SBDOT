%> @file "@BasicGaussianProcess/updateStochasticProcess.m"
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
%>	[this err dpsi] = updateStochasticProcess( this, hp )
%
% ======================================================================
%> Updates correlation part of the model
% ======================================================================
function [this, err, dpsi] = updateStochasticProcess( this, hp )

	err = [];
	
    % Number of samples...
    n = size( this.values, 1 );
    
    % store new set of model parameters
    this.hyperparameters = hp(:,this.HP);

    if this.optimIdx(:,this.LAMBDA)
        this.tau2 = hp{:,this.LAMBDA};
    else
        this.tau2 = 1; % Sigma is covariance matrix
    end

    % Calculate extrinsic/intrinsic matrices
    if nargout > 2
		[psi, dpsi] = this.extrinsicCorrelationMatrix(); % GP
        [Sigma, dSigma] = this.intrinsicCovarianceMatrix(); % noise GP
        
        % store derivative to lambda
        if this.optimIdx(1, this.LAMBDA)
            dpsi = [dSigma dpsi];
        end
	else
		psi = this.extrinsicCorrelationMatrix(); % GP
        Sigma = this.intrinsicCovarianceMatrix(); % noise GP
    end
    
    % Stochastic kriging:
    % if Sigma is a covariance matrix then sigma2 must be available and we store a covariance matrix
    if this.optimIdx(1,this.SIGMA2)

        % derivative to sigma2
        if nargout > 2
            dsigma2 = cell(1,1);
            dsigma2{1} = psi - diag(0.5.*ones(1,n));
            dpsi = [dsigma2 dpsi];
        end
        
        % psi is covariance matrix
        psi = psi.*10.^hp{:,this.SIGMA2} + Sigma;
    else
        % psi is correlation matrix
        psi = psi + Sigma;
    end
    
    % store intrinsic cov/corr matrix
    this.Sigma = Sigma;

    if this.options.lowRankApproximation
		rankMax = min( this.options.rankMax, n );
		[C, P] = cholincsp(psi, this.options.rankTol, rankMax );
		rank = size(C,1);
		
		if this.options.debug
			try
				if ~spok(C)
					lastwarn
				end
			catch e
				disp( e.getReport() );
			end
		end
		
		if rank < n
			fprintf(1,'WARNING: correlation matrix is rank %i of %i\n', rank, n );
		end
	else
		%% STANDARD
		% Cholesky factorization with check for pos. def.
		[C, rd] = chol(psi);
		P = 1:n;
		rank = size(C,1);

		if rd > 0 % not positive definite
            err = 'correlation matrix is ill-conditioned.';
            return;
            
            % would it be useful to allow low-rank approximation using standard chol ?
            % matrix not fully decomposed, use low-rank approximation (not
            % optimal!!!)
            %rank = rd-1;
            %fprintf(1,'WARNING: correlation matrix is rank %i of %i\n', rank, n );
		end
	end
	this.C = C';
	this.P = P;
	this.rank = rank;
  
    % NOTE:
    % C  is lower triangular
    % C' is upper triangular 
    % C*C' = psi(1:P,1:P)
end
