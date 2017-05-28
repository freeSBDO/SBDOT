%> @file "@BasicGaussianProcess/marginalLikelihood.m"
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
%>	[out dout] = marginalLikelihood( this, dpsi, dsigma2 )
%
% ======================================================================
%> Used for Maximum Likelihood Estimation (MLE)
%>
%> Papers:
%> - "Gaussian Processes for Machine Learning" (Chapter 5),
%>   C. E. Rasmussen and C. K. I. Williams,
%>   MIT Press, 2006
%> - "An adjoint for likelihood maximization"
%>   D.J.J. Toal, A.I.J. Forrester, N.W. Bressloff, A.J. Keane, C. Holden,
%>   Proc. of the Royal Society, 2009
% ======================================================================
function [out, dout] = marginalLikelihood( this, dpsi, dsigma2 )

	% Number of samples...
    n = size( this.values, 1 );
	
	% Negative of concentrated log-likelihood

    % Yt (and residual) is calculated twice (see updateRegression)
    Yt = this.C \ this.values(this.P,:);
    residual = Yt - this.Ft*this.alpha;
        
    % log( det(this.C*this.C') ) =
    lnDetPsi = 2.*sum(log(diag(this.C)));
   
    if this.optimIdx( 1, this.SIGMA2 )
        % this.C is covariance matrix instead of correlation matrix -> likelihood changes a bit
        % use the profile marginalized log-likelihood of Rasmussen 2006

        % profile marginalized log-likelihood
        out = 0.5 .* (sum(sum(residual.^2)) + lnDetPsi + n.*log(2.*pi)); % profile log-likelihood
    else
        % sigma2 is analytically optimized a priori
        % use concentrated log-likelihood
        out = 0.5 .* (n.*log(sum(this.sigma2)) + lnDetPsi);
    end
    
    % Derivative
    if nargout > 1
		dout = zeros( 1, length(dpsi) );

		%% Derivatives (analytical)
		for i=1:length(dpsi)
			% Partial derivative to hyperparameters i
			dpsiCurr = dpsi{i} + dpsi{i}';
            
            if this.optimIdx( 1, this.SIGMA2 )
                % From book of Rasmussen
                tmp = inv(this.C')*residual(:,1);
                dout(:,i) = -0.5 .* trace( (tmp*tmp' - inv(this.C') * inv(this.C)) * dpsiCurr );
            else
                % From Toal adjoint paper
                %dout(:,i) = residual2(:,1)' * invpsi * dpsiCurr * invpsi * residual2(:,1);
            
                % avoiding inverse
                resinvpsi = (this.C(1:this.rank,1:this.rank)' \ residual(:,1));

                dout(:,i) = resinvpsi' * dpsiCurr(this.P(1:this.rank),this.P(1:this.rank)) * resinvpsi;
                dout(:,i) = dout(:,i) ./ (2*mean(this.sigma2));

                tmp = this.C(1:this.rank,1:this.rank)' \ (this.C(1:this.rank,1:this.rank) \ dpsiCurr(this.P(1:this.rank),this.P(1:this.rank))); % expensive
                dout(:,i) = 0.5 * trace(tmp) - dout(:,i);
            end
        end
        
        % derivative to rho parameter (coKriging)
        if this.optimIdx(1,this.RHO)
            % only for concentrated log-likelihood
            assert( ~this.optimIdx( 1, this.SIGMA2 ) );
            dout = [0.5.*(n.* (dsigma2./sum(this.sigma2)) ) dout];
        end
        
		%{
        %> @todo Adjoint derivatives work, but are very slow due to naive implementation
		%% Adjoint
		T1 = residual; %C \ (C * residual);
		T2 = C' \ T1;

		% seed
		T2adj = - (C * residual) ./ (2.*sigma2);
		L1 = C'; L2 = C;

		% reverse backward substitution
		[L1adj, T1adj] = reverse_backwardSub( T2adj, L1, T2 );

		% reverse forward substitution
		L2adj = reverse_forwardSub( T1adj, L2, T1 );

		% adjoint of the log of the determinant of psi
		L3adj = diag( - 1 ./ diag( L2 ) );

		Ladj = L1adj' + L2adj + L3adj;

		% reverse cholesky factorisation
		Radj = sparse( reverse_cholesky( L2, Ladj ) );

		dout = zeros( length(hyperparameters), 1 );

		for i=1:length(dpsi)
			% Partial derivative to hyperparameters i and lambda (optional)
			% Take negative
			dout(i,:) = -sum( sum( dpsi{i}' .* Radj ) );
		end
		%}
    else
        dout = [];
    end
    
end