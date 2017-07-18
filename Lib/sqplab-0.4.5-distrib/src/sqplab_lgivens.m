function A = sqplab_lgivens (A,n,c,s)

%
% Left multiplication by a Givens rotation matrix.
%
% A = sqplab_lgivens (A,n,c,s)
%
% The matrix A(2,n) is replaced by G*A, where G is the Givens rotation
% matrix G = [c, -s; s, c], where c^2 + s^2 = 1 (note the change of
% sign with respect to rgivens).

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

for j = 1:n
  t1 = A(1,j);
  t2 = A(2,j);
  A(1,j) = c*t1-s*t2;
  A(2,j) = s*t1+c*t2;
end
