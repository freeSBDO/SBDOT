%> @file "corrgauss.m"
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
%>	[corr, dx, dtheta, rho] = corrgauss(theta, d)
%
% ======================================================================
%> @brief Gaussian correlation function
% ======================================================================
function  [corr, dx, dtheta, rho] = corrgauss(theta, d)

if nargin == 0
	corr = 'D';
	return;
end

[n m] = size(d);
theta = 10.^theta(:).';

inner = bsxfun( @times, -abs(d).^2, theta(ones(n,1),:) );
corr = exp(sum(inner, 2));

% Derivatives
if  nargout > 1
  % to the individual x_i's AND to all x_1,...,x_n
  dx = -2.*theta(ones(n,1),:) .* d .* corr(:,ones(1,m)); % individual (D columns)
  %dx = [dx -2.*theta(ones(n,1),:) .* corr(:,ones(1,m))]; % to all (1 column)
  
  % to theta
  dtheta = log(10) .* inner .* corr(:,ones(1,m));
end

% Rho
if nargout > 3
    rho = exp(inner);
end
