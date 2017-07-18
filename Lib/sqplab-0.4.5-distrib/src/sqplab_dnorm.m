function [vn] = sqplab_dnorm (v);

%
% [vn] = sqplab_dnorm (v);
%
% Computes the dual norm of the vector v. This norm must be the dual
% norm of the one computed by sqplab_pnorm ().
%
% In the present case, this is the infinity norm.

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

  vn = norm(v,inf);

  return
