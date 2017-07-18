function [L, p] = cholincsp(X, tol, maxRank)
%
% CHOLINCSP - Incomplete Cholesky factorization with symmetric pivoting
%
%    R = CHOLINCSP(X) computes an inclomplete Cholesky factorization of a
%    symmetrix matrix X, such that R'*R is a permutation of the rows and
%    columns of X.  The columns of Cholesky factor R are computed one at
%    a time, with symmetric pivoting, as described in [1]. 
%
%    [R,I] = CHOLINC(X) also gives the permutation in I, such that
%    R*R' = X(I,I) .  If R contains n columns, then the first n elements of I
%    specify a set of linearly independent columns forming a basis for the
%    remaining columns of X.
%
%    R = CHOLINCSP(X, TOL) allows the termination criterion (TOL) to be
%    adjusted (a default value of 1e-12 is used if only one argument is
%    given.
%
%    References :
%
%       [1] Fine, S. and Scheinberg, K., "Efficient SVM training using
%           low-rank kernel representations", Journal of Machine Learning
%           Research, vol. 2, pp 243-264, December 2001.
%
%    See also : CHOLINCSP_TEST

%
% File        : cholincsp.m
%
% Date        : Wednesday 11th August 2004
%
% Author      : Gavin C. Cawley (with help from Katya Scheinberg)
%				Modified by Ivo Couckuyt:
%					- operate only on the upper triangle (allows large sparse
%					matrices)
%
% Description : Vectorised MATLAB implementation of Fine and Scheinberg's
%               incomplete Cholesky factorisation with symmetric pivoting [1].
%
% References  : [1] Fine, S. and Scheinberg, K., "Efficient SVM training
%                   using low-rank kernel representations", Journal of Machine
%                   Learning Research, vol. 2, pp 243-264, December 2001.
%
% History     : 10/08/2004 - v1.00
%
% To do       : Write an even faster MEX version using BLAS etc!
%
% Copyright   : (c) Dr Gavin C. Cawley, August 2004.
%
%    This program is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 2 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program; if not, write to the Free Software
%    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
%

if nargin == 1

   tol = 1e-12;

end

m         = size(X,1);
nzmax = (m*(m+1))/2;
p         = 1:m;
trc       = zeros(1,m);
L         = sparse( ones(1,m), 1:m, X(1,:),m,m,nzmax );
diagonal  = sub2ind([m,m], 1:m, 1:m); 

if ~exist( 'maxRank', 'var' )
	maxRank = m;
end
	
for i=1:maxRank

   L(diagonal(i:m)) = X(diagonal(p(i:m))) - sum(L(1:i-1,i:m).^2,1);

   dL = diag(L);
   trc(i)=sum(dL(i:m));
   if  trc(i) <= tol

     break

   else

      [v q] = max(dL(i:m));

      q = q+i-1;

      t    = p(i);
      p(i) = p(q);
      p(q) = t;

      tt=L(1:i-1,i);
      L(1:i-1,i)=L(1:i-1,q);
      L(1:i-1,q)=tt;

      v = sqrt(v);
      L(i,i)=v; 
	  
	  % take only elements from upper triangle
	  % original: X(p(i),p(i+1:m))'
	  idx1 = min( p(i+1:m), p(i) );
	  idx2 = max( p(i+1:m), p(i) );
	  idx = sub2ind([m,m], idx1, idx2); 
	  
      L(i,i+1:m) = (X(idx) - L(1:i-1,i)'*L(1:i-1,i+1:m))/v;
   end

end

if i ~= m
   L = L(1:i-1,:);
end

% bye bye...

