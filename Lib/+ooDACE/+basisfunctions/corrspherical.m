%> @file "corrspherical.m"
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
%>	[corr, dx, dtheta, rho] = corrspherical(theta, d)
%
% ======================================================================
%> @brief Spherical correlation function
% ======================================================================
function  [corr, dx, dtheta, rho] = corrspherical(theta, d)

if nargin == 0
	corr = 'D';
	return;
end

[n m] = size(d);
theta = 10.^theta(:).';
 
inner = min(abs(d) .* theta(ones(n,1),:), 1);
term = 1 - inner .* (1.5 - .5*inner.^2);
corr = prod(term, 2);

% Derivatives
if  nargout > 1
  % to x
  dx = zeros(n,m);
  for j=1:m
    dxj = 1.5.*theta(j) * sign(d(:,j)).*(inner(:,j).^2 - 1);
    dx(:,j) = prod(term(:,[1:j-1 j+1:m]),2) .* dxj;
  end

  % to theta
  dtheta = zeros(n,m);
  for j=1:m
    dthetaj = 1.5.*theta(j).*abs(d(:,j)).*(inner(:,j).^2 - 1);
    dtheta(:,j) = prod(term(:,[1:j-1 j+1:m]),2) .* dthetaj;
  end
end

% Rho
if nargout > 3
    rho = term;
end
