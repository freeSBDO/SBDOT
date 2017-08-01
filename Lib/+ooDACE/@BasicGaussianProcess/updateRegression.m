%> @file "@BasicGaussianProcess/updateRegression.m"
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
%>	[this err dsigma2] = updateRegression( this, F, hp )
%
% ======================================================================
%> Updates regression part of the model
% ======================================================================
function [this, err, dsigma2] = updateRegression( this, F, hp )

	err = [];
       
    %> @todo Rho is only used by co-kriging, can we abstract this somehow ?
    % if using co-kriging calculate values{1} - rho*values{2}
    if this.optimIdx(1,this.RHO) && size(this.values,2) > 1
        assert( ~isinf( hp{:,this.RHO} ) );
        
        values2 = this.values(:,2);
        
        this.rho = hp{:,this.RHO};
        this.values = this.values(:,1) - this.rho.*this.values(:,2);
    end
	
    %% Get least squares solution

    % decorrelation transformation:
    % Yt - Ft*coeff = inv(C)Y - inv(C)F*coeff
    % so Ft = inv(C)F <=> C Ft = F -> solve for Ft

	% Forward substitution
	Ft = this.C \ F(this.P,:); % T1

    % Bayesian Linear regression:
    %tmp = inv(this.F'*this.F + A)*(this.F'*this.F * betaPrior + A*betaPriorMean

    % Ft can now be ill-conditioned -> QR factorisation of Ft = QR
    [Q, R] = qr(Ft,0);
    if  rcond(R) < 1e-10
		% Check F
		err = 'F/Ft is ill-conditioned.';
		return;
    end

    % Now we know Ft is good, compute Yt
    % so Yt = inv(C)Y <=> C Yt = Y -> solve for Yt
    Yt = this.C \ this.values(this.P,:);
	
    % transformation is done, now fit it:
    % Q is unitary = orthogonal for real values -> inv(Q) = Q'
    alpha = R \ (Q'*Yt); % polynomial coefficients

	% residual2 = values(this.P,:) - this.F * alpha % simple
    % residual2 = C * residual; % take correlation into account for real variance
    % sigma2 = (residual' * T2) ./ n; % simple
    residual = Yt - Ft*alpha;

    if this.optimIdx( 1, this.SIGMA2 )
        % take process variance from hyperparameters (stochastic kriging)
        this.sigma2 = 10.^hp{:,this.SIGMA2};
    else
        % compute process variance analytically    
        this.sigma2 = sum(residual.^2) ./ size(this.values, 1);
        
        % Reinterpolation of the prediction variance (Forrester2006)
        % modif_cdu, cell : 
        if iscell(this.options.reinterpolation)
            if this.options.reinterpolation{1} || this.options.reinterpolation{2}
                tmp = (this.C*this.C') - this.Sigma;
                this.sigma2_reinterp = (residual' * tmp * residual) ./ size(this.values,1);
            end
        else
            if this.options.reinterpolation
                tmp = (this.C*this.C') - this.Sigma;
                this.sigma2_reinterp = (residual' * tmp * residual) ./ size(this.values,1);
            end
        end
    end
    
    % needed for derivatives for coKriging
    if nargout > 2 && this.optimIdx(1,this.RHO)
        dYt = this.C \ -values2;
        dalpha = R \ (Q'*dYt);
        dresidual = dYt - Ft*dalpha;
        
        %this.sigma2 = sum(residual.^2) ./ size(this.values, 1);
        dsigma2 = sum(2.*residual.*dresidual) ./ size(this.values, 1);
    else
        dsigma2 = [];
    end
    
    %% keep
	this.alpha = alpha;
	
	% inv(C11') * inv(C) * values or (inv(C)*residual)
	this.gamma = this.C(1:this.rank,1:this.rank)' \ residual;
	
	this.Ft = Ft;
	this.R = R;
end
