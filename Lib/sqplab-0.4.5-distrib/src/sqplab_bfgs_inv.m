function [W,info] = sqplab_bfgs_inv (W,y,s,first,info,options,values);

%
% [W,info] = sqplab_bfgs_inv (W,y,s,first,info,options,values);
%
% This procedure computes the inverse BFGS update of the matrix W,
% which is supposed to be a positive definite approximation of some
% Hessian. If y'*s is not sufficiently positive and
% options.algo_descent is set to values.powell, Powell's correction is
% applied to y.
%
% On entry:
%   W: matrix to update
%   y: gradient variation
%   s: point variation
%   first: if true, the procedure will initialize the matrix W to a
%       multiple of the identity before the update
%
% On return:
%   W: updated matrix

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

%-----------------------------------------------------------------------
% parameter
%-----------------------------------------------------------------------

  eta = 0.2;    % constant for Powell corrections

%-----------------------------------------------------------------------
% initalization
%-----------------------------------------------------------------------

  info.flag = values.success;

%-----------------------------------------------------------------------
% prepare the update of W, by computing ys = y'*s and Wy = W*y
%-----------------------------------------------------------------------

  ys = y'*s;
  if options.verbose >= 4; fprintf(options.fout,': y''*s/(y''*y) = %9.3e',ys/(y'*y)); end
  Wy = W*y;
  yWy = y'*Wy;
  if yWy <= 0
    info.flag = values.fail_strange;
    if options.verbose
      fprintf(options.fout,'\n\n### sqplab: BFGS inverse Hessian approximation is not positive definite:');
      fprintf(options.fout,'\n            y''*W*y = %f <= 0\n',yWy);
    end
    return
  end
  if (options.algo_descent == values.powell) & (ys < eta*yWy)    % Powell's correction
    pc = (1-eta)*yWy/(yWy-ys);
    if options.verbose >= 4; fprintf(options.fout,'\n  Powell''s corrector = %9.3e',pc); end
    s = pc*s+(1-pc)*Wy;
    ys = y'*s;  % update ys, since s has changed
    if options.verbose >= 4, fprintf(options.fout,' (new y''*s/(y''*y) = %9.3e)',ys/(y'*y)); end
    if ys <= 0
      info.flag = values.fail_strange;
      if options.verbose; fprintf(options.fout,'\n\n### sqplab: y''*s = %8.1e not positive despite correction:\n',ys)'; end
      return
    end
  elseif ys <= 0
    if options.verbose; fprintf(options.fout,'\n\n### sqplab: y''*s = %8.1e is nonpositive\n',ys)'; end
    info.flag = values.fail_strange;
    return
  end

%-----------------------------------------------------------------------
% case when the matrix has to be initialized
%-----------------------------------------------------------------------

  if first
    ol = ys/(y'*y);     % smaller inverse matrix, smaller step
%   ol = (s'*s)/ys;     % larger inverse matrix,  larger step
    if options.verbose >= 4, fprintf(options.fout,'\n  OL coefficient = %9.3e',ol); end
    W = ol*eye(length(y));
    Wy = ol*y;
  end

%-----------------------------------------------------------------------
% update W by the inverse BFGS formula
%-----------------------------------------------------------------------

  % scale y and s

  ys = sqrt(ys);
  y = y/ys;
  s = s/ys;
  Wy = Wy/ys;

  % update W

  W = W - s*Wy';
  Wy = W*y;
  W = W - Wy*s' + s*s';

  if options.verbose >= 6
    eigW = sort(eig(W));
    fprintf(options.fout,'\n  eig(W): min = %g, max = %g, cond = %g',min(eigW),max(eigW),max(eigW)/min(eigW));
  end

return
