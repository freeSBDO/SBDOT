%> @file "covmatern32.m"
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
%>	[corr, dx, dhp, rho] = corrmatern32_variance(hp, d)
%
% ======================================================================
%> @brief Class of Matern covariance functions (nu = {1/2 3/2 5/2}
%>
%> Implementation based on the book of Rasmussen et al.
%> - "Gaussian Processes for Machine Learning" (Chapter 4),
%>   C. E. Rasmussen and C. K. I. Williams,
%>   MIT Press, 2006
%>
%> The correlation function is:
%>   corr = f( sqrt(nud)*dist2 ) * exp(-sqrt(nud)*dist2)
%>   with nud = 2.*nu
% ======================================================================
function [corr, dx, dhp, rho] = corrmatern32_variance(hp, d)

if nargin == 0
	corr = '1+D';
	return;
end

[n, m] = size(d);

sigma2 = 10.^hp(1);
ell = 10.^(hp(2:end));

% hardcoded
nud = 3; % {1, 3, 5} - nu = nud/2;

% scaled distance
dist2 = bsxfun( @times, d.^2, ell ); % diag(d*ell*d') );
dist = sqrt( sum(dist2,2) );

t = sqrt(nud).* dist;

if nud == 1
    f = ones(n,1); % f(t)=1
    df = zeros(n,m);
elseif nud == 3
    f = 1 + t; % f(t)=1+t
    df = ones(n,m);
elseif nud == 5
    f = 1 + t .* (1+t./3); % f(t)=1+t+t²/3
    df = (1 + 2 .* t(:,ones(1,m)) ./ 3);
end

right = exp(-t);
corr = sigma2 .* f.*right;

% Derivatives
if nargout > 1
    dist( dist == 0 ) = eps; % avoid division by zero
    
    % to the individual x_i's
    %dtx = 0.5 .* sqrt(nud) .* 2 .* d .* ell(ones(n,1),:) ./ dist(:,ones(1,m));
    dtx = sqrt(nud) .* d .* ell(ones(n,1),:) ./ dist(:,ones(1,m));
    dx = (df - f(:,ones(1,m))) .* dtx .* right(:,ones(1,m));

    % to theta
    dt = 0.5 .* sqrt(nud) .* log(10) .* dist2 ./ dist(:,ones(1,m));
    dhp = [f.*right (df - f(:,ones(1,m))) .* dt .* right(:,ones(1,m))];
end

end
