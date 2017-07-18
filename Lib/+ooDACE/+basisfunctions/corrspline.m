%> @file "corrspline.m"
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
%>	[corr, dx, dtheta, rho] = corrspline(theta, d)
%
% ======================================================================
%> @brief Cubic spline correlation function,
% ======================================================================
function  [corr, dx, dtheta, rho] = corrspline(theta, d)

if nargin == 0
	corr = 'D';
	return;
end

[n m] = size(d);
theta = 10.^theta(:).';

nm = n*m;   term = zeros(nm,1);
xi = reshape(abs(d) .* theta(ones(n,1),:), nm,1);

% Contributions to first and second part of spline
i1 = find(xi <= 0.2);
i2 = find(0.2 < xi & xi < 1);
if  ~isempty(i1)
  term(i1) = 1 - xi(i1).^2 .* (15  - 30*xi(i1));
end
if  ~isempty(i2)
  term(i2) = 1.25 * (1 - xi(i2)).^3;
end

% prod up
term = reshape(term,n,m);
corr = prod(term, 2);

% Derivatives
if  nargout > 1
  % to x
  u = reshape(sign(d) .* theta(ones(n,1),:), nm,1);
  dx = zeros(nm,1);
  if  ~isempty(i1)
    dx(i1) = u(i1) .* ( (90*xi(i1) - 30) .* xi(i1) );
  end
  if  ~isempty(i2)
    dx(i2) = -3.75 * u(i2) .* (1 - xi(i2)).^2;
  end
  ii = 1:n;
  for j = 1:m
    sj = term(:,j);  term(:,j) = dx(ii);
    dx(ii) = prod(term,2);
    term(:,j) = sj;
    ii = ii + n;
  end
  dx = reshape(dx,n,m);

  % to theta
  dtheta = zeros(nm,1);
  u = reshape(log(10) .* abs(d) .* theta(ones(n,1),:), nm,1);
  
  if  ~isempty(i1)
    dtheta(i1) = 30 .* xi(i1) .* u(i1) .* (3 .* xi(i1) - 1);
  end
  if  ~isempty(i2)
    dtheta(i2) = -3.75 .* u(i2) .* (1 - xi(i2)).^2;
  end
  ii = 1:n;
  for j = 1:m
    sj = term(:,j);  term(:,j) = dtheta(ii);
    dtheta(ii) = prod(term,2);
    term(:,j) = sj;
    ii = ii + n;
  end
  dtheta = reshape(dtheta,n,m);
  
end

% Rho
if nargout > 3
    rho = term;
end
