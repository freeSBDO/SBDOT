%> @file "@BasicGaussianProcess/predict.m"
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
%>	[y sigma2] = predict(this, points)
%
% ======================================================================
%> @pre The kriging object should be fitted using a dataset (BasicGaussianProcess::fit)
% ======================================================================
function [y, sigma2] = predict(this, points)

	%% Constants
    nx = size(points,1);
	outDim = length(this.sigma2); % number of outputs
		
	%% Regression function	
    F = this.regressionMatrix(points); % model matrix (also known as Vandermonde matrix)
    poly = F * this.alpha;
	
    %% GP part
    % distance matrix
    corr = this.extrinsicCorrelationMatrix(points); % K*'
    if this.optimIdx(1, this.SIGMA2)
        gp = (this.sigma2 * corr) * this.gamma;
    else
        gp = corr(:,this.P(1:this.rank)) * this.gamma;
    end
    
    % prediction
    y = poly + gp;
	
    % Calculate sigma
	if nargout > 1
        
        % Reinterpolation: only use extrinsic correlation matrix.
        % Affected variables: C, sigma2, R and Ft
        % modif_cdu, cell : 
        if iscell(this.options.reinterpolation)
            opt_reint_bool = this.options.reinterpolation{1} || this.options.reinterpolation{2};
        else
            opt_reint_bool = this.options.reinterpolation;
        end
        
        if opt_reint_bool
            corrt = this.C_reinterp(1:this.rank,1:this.rank) \ corr';
            
            u = this.Ft_reinterp.' * corrt - F.';
            v = this.R_reinterp \ u;
            % modif_cdu
            if isa( this , 'ooDACE.CoKriging' )
                tmp = (sum(v.^2,1) - sum(corrt.^2,1))';
                sigma2 = repmat(this.sigma2,nx,1) + repmat(tmp, 1, outDim);
            else
                tmp = (1 + sum(v.^2,1) - sum(corrt.^2,1))';
                
                sigma2 = repmat(this.sigma2_reinterp,nx,1) .* repmat(tmp,1,outDim);
            end
        else
            corrt = this.C(1:this.rank,1:this.rank) \ corr(:,this.P(1:this.rank))';

            u = this.Ft.' * corrt - F.';
            v = this.R \ u;
            
            % separate case for CoKriging and Stochastic Kriging
            if isa( this , 'ooDACE.CoKriging' ) || this.optimIdx(:,this.SIGMA2)
                tmp = (sum(v.^2,1) - sum(corrt.^2,1))';
                sigma2 = repmat(this.sigma2,nx,1) + repmat(tmp, 1, outDim);
            else
                tmp = (1 + sum(v.^2,1) - sum(corrt.^2,1))';
                sigma2 = repmat(this.sigma2,nx,1) .* repmat(tmp, 1, outDim);
            end
        end
	end
end
