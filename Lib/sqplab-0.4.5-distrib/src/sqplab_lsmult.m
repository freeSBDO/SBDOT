function [lm,info] = sqplab_lsmult (simul,x,ms,lb,ub,info,options,values);

%
% [lm,info] = sqplab_lsmult (simul,x,ms,lb,ub,info,options,values);
%
% This procedure computes an exact (if ms=0) or approximate (if ms>0)
% least-squares multiplier 'lm'. If ms = 0, it solves in lm the
% quadratic optimization problem:
%
%   min || g+A'*lm ||^2
%   subject to possible bounds on lm,
%
% where g = info.g, lm = lm(1:n+mi+me) and A' = [ones(n) info.ai'
% info.ae']. When ms > 0 the solution is only approximate, since the
% Jacobian cs'(x) is supposed to be unavailable. Then sqplab_lsmult
% computes lm(1:n+mi+me) as above and lm(n+mi+me+1:n+mi+me+ms) by the
% formula
%
%   lm(n+mi+me+1:n+mi+me+ms) = - asm'*(g+A'*lm).
%
% where asm is a right inverse of as=cs'(x). This corresponds to making
% a 1-step relaxation method in lm(1:n+mi+me) first and
% lm(n+mi+me+1:n+mi+me+ms) next.
%
% A multiplier associated with an inequality constraint having 
% - infinite lower and upper bounds vanishes,
% - infinite lower bound and finite upper bound is nonnegative,
% - finite lower bound and infinite upper bound is nonpositive,
% - finite lower bound and finite upper bound can have any sign.
% A lower (resp. upper) bound is considered as infinite if its value is
% empty or <= -options.inf (resp. empty or >= options.inf).
%
% On entry:
%   simul: simulator name, see the documentation of sqplab
%   ms: number of state constraints
%   info.ci = ci(x)
%   lb: (optional or (n+mi) x 1) lower bounds on the n variables and mi
%       inequality constraints, is considered as empty if not present
%   ub: (optional or (n+mi) x 1) upper bounds on the n variables and mi
%       inequality constraints, is considered as empty if not present
%
% On return:
%   lm: computed least-squares multiplier, more precisely
%       lm(1:n): multiplier associated with the bounds on the variables
%       lm(n+1:n+mi): multiplier associated with the mi inequality
%           constraints
%       lm(n_mi+1:n+mi+me): multiplier associated with the me equality
%           constraints

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

% Initialization

  lm        = [];
  info.flag = values.success;

% Dimensions

  n = length(info.g);
  mi = 0; if (nargin >= 2), mi = size(info.ai,1); end
  me = 0; if (nargin >= 3), me = size(info.ae,1); end

% Check input arguments

  if (nargin < 4) | isempty(lb)
    lb = -options.inf*ones(n+mi,1);
  else
    lb = lb(:);
    if any(size(lb) ~= [n+mi 1])
      fprintf('\n### sqplab_lsmult: incorrect size of lb\n\n');
      info.flag = values.fail_strange;
      return
    end
  end
  if (nargin < 5) | isempty(ub)
    ub = options.inf*ones(n+mi,1);
  else
    ub = ub(:);
    if any(size(ub) ~= [n+mi 1])
      fprintf('\n### sqplab_lsmult: incorrect size of ub\n\n');
      info.flag = values.fail_strange;
      return
    end
  end

% Form the matrix A

  A = [eye(n); info.ai; info.ae];

% Compute the lower (lo) and upper (up) bounds on lm

  lo = -inf*ones(n+mi,1);
  up =  inf*ones(n+mi,1);
  for i=1:n+mi
    if (lb(i) <= -options.inf); lo(i) = 0; end
    if (ub(i) >=  options.inf); up(i) = 0; end
    % at this point, if there are lower and upper bounds on [x,ci], the multiplier can take any sign;
    % take additional constraint in case [x,ci] is active at a bound
    if i <= n
      if (lb(i) > -options.inf) & (abs(x(i)-lb(i)) < options.dxmin); up(i) = 0; end     % the multiplier must be <= 0
      if (ub(i) <  options.inf) & (abs(x(i)-ub(i)) < options.dxmin); lo(i) = 0; end     % the multiplier must be >= 0
    else
      if (lb(i) > -options.inf) & (abs(info.ci(i-n)-lb(i)) < options.dxmin); up(i) = 0; end     % the multiplier must be <= 0
      if (ub(i) <  options.inf) & (abs(info.ci(i-n)-ub(i)) < options.dxmin); lo(i) = 0; end     % the multiplier must be >= 0
    end
  end

% fprintf ('\nlower bound  upper bound\n');
% for i = 1:n
%   if ~isempty(lb)
%     fprintf ('%11.4e',lo(i));
%   else
%     fprintf ('            ');
%   end
%   if ~isempty(ub)
%     fprintf ('  %11.4e',up(i));
%   end
%   fprintf ('\n');
% end

% Solve the QP

  options_qp = optimset ('Display',    'off', ...
                         'Diagnostics','off', ...
                         'LargeScale', 'off');
  [lm,tmp,qp_flag] = quadprog (A*A',A*info.g,[],[],[],[],lo,up,[],options_qp);
% [lm,tmp,qp_flag] = quadprog (A*A',A*info.g,[],[],[],[],lo,up);
  if qp_flag ~= 1
    fprintf('\n### sqplab_lsmult: multiplier is set to zero (QUADPROG exitflag = %0i', qp_flag);
    switch qp_flag
      case 3
        fprintf(', too small change in the objective');
      case 4
        fprintf(', local minimizer found');
      case 0
        fprintf(', max iteration exceeded');
      case -2
        fprintf(', infeasible QP');
      case -3
        fprintf(', unbounded QP');
      case -4
        fprintf(', ascent direction generated');
      case -7
        fprintf(', too small search direction');
    end
    fprintf(')\n\n');
    lm = zeros(n+mi+me,1);
  end

% If ms > 0, compute the last part on lm: lm(n+mi+me+1:n+mi+me+ms) = - asm'*(g+A'*lm).

  if ms
    info.nsimul(14) = info.nsimul(14) + 1;
    [outdic,asmv] = simul(14,x,info.g+A'*lm);
    if outdic
      if outdic == 2,
        if options.verbose; fprintf(options.fout,'\n### sqplab: the simulator wants to stop\n\n'); end;
        info= values.fail_on_simul;
        return
      elseif outdic > 2
        if options.verbose; fprintf(options.fout,'\n### sqplab: error with the simulator (outdic = %0i)\n\n',outdic); end;
        info= values.fail_on_simul;
        return
      end
    end
    lm(n+mi+me+1:n+mi+me+ms) = -asmv;
  end

return
