function [merit,cshn] = sqplab_merit (x,f,ci,ce,cs,lb,ub,sigma)

%
% [merit,cshn] = sqplab_merit (x,f,ci,ce,cs,lb,ub,sigma)
%
% This procedure evaluates the merit function.
%
% On entry:
%   x: primal variable at which the merit function has to be evaluated,
%   f: cost function value at x,
%   ci,ce,cs: inequality/equality/state constraint value at x,
%   lb,ub: lower/upper bounds on x and ci,
%   sigma: penalty parameter value.
%
% On return:
%   merit: merit function value = f - sigma * pnorm(c^#)
%   cshn: pnorm(c^#)

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

% Evaluate the merit function
  
  if isempty(sigma)     % unconstrained problem
    cshn = [];
    merit = f;
  else                  % constrained problem
    c = [x;ci];
    csh = [max(max(0,lb-c),c-ub);ce;cs];
    cshn = sqplab_pnorm(csh);
    merit = f+sigma*cshn;
  end

return
