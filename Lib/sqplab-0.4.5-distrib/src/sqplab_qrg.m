function [Q,R] = sqplab_qrg (A)

%
% Orthogonal-triangular factorization, using Givens rotations.
%
% [Q,R] = sqplab_qrg (A)
%
% Sqplab_qrg produces a QR factorization of the matrix A: R is an upper
% triangular matrix of the same dimension as A and Q is an orthogonal
% matrix. There will hold A = Q*R. Givens rotations are used to form Q.
% The matlab function QR uses Householder reflexions.
%
% See also QR, QRDELETE, QRINSERT.

%-----------------------------------------------------------------------
%
% Author: Jean Charles Gilbert, INRIA.
%
% Copyright 2008, 2009, INRIA.
%
% SQPlab is distributed under the terms of the Q Public License version
% 1.0.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the Q Public
% License version 1.0 for more details.
%
% You should have received a copy of the Q Public License version 1.0
% along with this program.  If not, see
% <http://doc.trolltech.com/3.0/license.html>.
%
%-----------------------------------------------------------------------

% dimensions

  [m,n] = size(A);

% initialization

  R = A;
  Q = eye(m);
  
% computation

  for j = 1:n     % consider one column after the other
    for i = m:-1:j+1      % zero the last m-j element of the column
      [c,s,r] = sqplab_givens (R(i-1,j),R(i,j));
      R(i-1,j) = r;
      R(i,j) = 0;
      if j<n, R(i-1:i,j+1:n) = sqplab_lgivens (R(i-1:i,j+1:n),n-j,c,s); end
      Q(:,i-1:i) = sqplab_rgivens (Q(:,i-1:i),m,c,s);
    end
  end

return
