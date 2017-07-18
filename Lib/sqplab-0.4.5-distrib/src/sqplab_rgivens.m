function A = sqplab_rgivens (A,m,c,s)

%
% Right multiplication by a Givens rotation matrix.
%
% A = sqplab_rgivens (A,m,c,s)
%
% The matrix A(m,2) is replaced by A*G, where G is the Givens rotation
% matrix G = [c, s; -s, c], where c^2 + s^2 = 1 (note the change of
% sign with respect to lgivens).

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

for i = 1:m,
  t1 = A(i,1);
  t2 = A(i,2);
  A(i,1) = c*t1-s*t2;
  A(i,2) = s*t1+c*t2;
end
