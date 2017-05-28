%> @file "@BasicGaussianProcess/predict_derivatives.m"
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
%>	[dy dsigma2] = predict_derivatives(this, point)
%
% ======================================================================
%> NOTE:
%>  - limited to one point at a time (x is a vector)
%> @pre The kriging object should be fitted using a dataset (BasicGaussianProcess::fit)
% ======================================================================
function [dy, dsigma2] = predict_derivatives(this, point)

	%% Constants
    [nx, mx] = size(point);
	dim_out = length(this.sigma2);

	assert( nx == 1, 'Prediction of derivatives supports only one point at a time.' );
    
    %% Regression function
	
	% model matrix (this.regressionFcn is degrees matrix)
    [F, dF] = this.regressionMatrix(point);
	
    %% Stochastic process (correlation part)
    [corr, dx] = this.extrinsicCorrelationMatrix(point);

    %% Jacobians (gradients)
    
	% of prediction mean
	dy = this.alpha.' * dF.' + this.gamma.' * dx;
	
	% of sigma2 (if needed)
	if nargout > 1		
        % gradient/Jacobian of MSE wanted
		
		% scaled
		corrt = this.C(1:this.rank,1:this.rank) \ corr.';
		u = this.Ft.' * corrt - F.';
		v = this.R \ u;
        
		Rv = this.R' \ v;
		g = (this.Ft * Rv - corrt)' * (this.C(1:this.rank,1:this.rank) \ dx) - (dF * Rv)';
		
		% unscaled
		dsigma2 = repmat(2 * this.sigma2',1,mx) .* repmat(g,dim_out,1);
	end
end
