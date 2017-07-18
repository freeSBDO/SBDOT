%> @file "corrlin.m"
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
%>	[corr, dx, dtheta, rho] = corrlin(theta, d)
%
% ======================================================================
%> @brief Linear correlation function,
% ======================================================================
function  [corr, dx, dtheta, rho] = corrlin(theta, d)

if nargin == 0
	corr = 'D';
	return;
end

[n m] = size(d);
theta = 10.^theta(:).';

inner = max(1 - abs(d) .* theta(ones(n,1),:), 0);
corr = prod(inner, 2);

% Derivatives
if  nargout > 1
  % to x
  dx = zeros(n,m);
  for  j = 1 : m
    dxj = (-theta(j) * sign(d(:,j)) );
    dx(:,j) = prod(inner(:,[1:j-1 j+1:m]),2) .* dxj;
  end

  % to theta
  % Derivative of min/max via
  % min(a,b) = 0.5(a+b-abs(a-b))
  % min(a,b) = -max(-a,-b)
  % or use branch (if x > a else ...)
  dtheta = zeros(n,m);
  for j=1:m
    dthetaj = theta(j) .* abs(d(:,j));
	dthetaj(dthetaj >= 1,:) = 0; % derive right side of max() (see inner statement above)
    
    dtheta(:,j) = prod(inner(:,[1:j-1 j+1:m]),2) .* -log(10).*dthetaj;
  end
end

% Rho
if nargout > 3
    rho = inner;
end
