function [c,s,r] = sqplab_givens (a,b)

%
% [c,s,r] = sqplab_givens (a,b)
%
% Being given a vector [a;b], sqplab_givens returns the elements 'c'
% and 's' of the orthogonal Givens matrix G = [c, -s; s, c], as well as
% the scalar 'r' such that G*[a;b] = [r;0].

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

  if b == 0
    c = 1; s = 0; r = a;
  else
    if abs(b) > abs(a)
      t = -a/b; s = -1/sqrt(1+t^2); c = t*s;
    else
      t = -b/a; c = 1/sqrt(1+t^2); s = t*c;
    end
  end
  r = c*a-s*b;

return
