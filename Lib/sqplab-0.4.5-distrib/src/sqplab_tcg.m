function [x,info] = sqplab_tcg (A,b,delta,max_iter,tol,plevel,fout);

% [x,info] = sqplab_tcg (A,b,delta,max_iter,tol,plevel,fout);
%
% Solves A x = b for x, by Steihaug's conjugate gradient (CG) method,
% where A is a symmetric (possibly indefinite) matrix. CG iterations
% starts from x = 0, up to one of the situations described below by info
% occurs.
%
% On entry
%   A: symmetric matrix of the linear system
%   b: RHS of the linear system
%   delta: trust region radius
%   max_iter: maximum iterations allowed
%   tol: x is considered a solution if the Euclidean norm of the
%     gradient A*x-b is less than tol.
%   plevel: printing level
%     =0: don't print anything
%     >0; print on fout
%   fout: printing channel
%
% On return
%   info is a structure providing information on the run
%     info.curv is the last encountered curvature d'*Ad/(d'*d) (not a
%       field if no iteration has been performed)
%     info.flag is the return code
%       = 0: convergence is obtained, up to the given tolerance tol: the
%            final x is the solution of the LS,
%       =-1: stop on max_iter,
%       = 1: the boundary of the ball of radius delta is encountered:
%            the final x is on the boundary of the ball
%       = 2: a negative curvature direction has been encountered: the
%            final x is on the boundary of the ball.
%     info.iter is the number of CG iterations
%     info.prec is the final precision, the l2-norm of the residual A*x-b
%   x is the computed approximate solution

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

  x = zeros(size(b));   % initial x = 0
  cost = 0;             % initial cost
  g = -b;	        % initial gradient (initial iterate is 0)
  g2 = g'*g;            % initial |g|^2

  tol2 = tol*tol;       % square of the tolerance
  delta2 = delta*delta; % square of the trust region radius

  dAd = [];             % for the test isempty below

  if plevel;
    fprintf (fout,'\n    TCG solver; required tolerance %8.2e',tol)
%   fprintf (fout,'\n    xxxx  xxxxxxxxxxxxxx  xxxxxxx  xxxxxxxxx  xxxxxxxx  xxxxxxxx'); end
    fprintf (fout,'\n    iter       cost        |res|   curvature  stepsize   |step|');
  end

%-----------------------------------------------------------------------
% Main loop.
%-----------------------------------------------------------------------
% At the beginning of the loop the following variables are supposed
% known:
% - g (gradient at the current iterate)
% - g2 = g'*g
% - g2_ = g_'*g_ (g_ is the previous gradient, if iter > 1)
% - d (previous direction, if iter > 1)
%-----------------------------------------------------------------------

  iter = 0;

  while 1

    iter = iter + 1;
    if plevel; fprintf (fout,'\n    %4i  %14.7e  %7.1e',iter,cost,sqrt(g2)); end

    % stop on convergence

    if g2 <= tol2
      info.flag = 0;
      break
    end

    % stop on iteration

    if iter > max_iter
      iter = max_iter;
      info.flag = -1;
      break
    end

    % new conjugate direction

    if iter == 1
      d = -g;
    else
      d = -g + (g2/g2_) * d;
    end

    % matrix*vector product and curvature verification

    Ad = A*d;

    dAd = d'*Ad;
    if plevel; fprintf (fout,'  %9.2e',dAd/(d'*d)); end
    if dAd <= 0		% negative curvature direction
      [x,alpha] = dogleg (x, x+d, delta);
      info.flag = 2;
      if plevel
        fprintf (fout,'  %8.2e  %8.2e',alpha,norm(x));
        cost = 0.5*(x'*A*x)-b'*x;
        fprintf (fout,'\n    %4i  %14.7e  %7.1e',iter+1,cost);
      end
      break
    end
    
    % new iterate

    alpha = - (g'*d)/dAd;
    xx = x + alpha * d;
    if plevel; fprintf (fout,'  %8.2e',alpha); end
    
    % intersection with the sphere

    if xx'*xx > delta2		% new iterate is outside the trust region
      [x,alpha] = dogleg (x, xx, delta);
      info.flag = 1;
      if plevel
        fprintf (fout,'  %8.2e  %8.2e',alpha,norm(x));
        cost = 0.5*(x'*A*x)-b'*x;
        fprintf (fout,'\n    %4i  %14.7e  %7.1e',iter+1,cost);
      end
      break
    else
      x = xx;
    end
    if plevel; fprintf (fout,'  %8.2e',norm(x)); end
    
    % new gradient and cost

    g = g + alpha * Ad;
    g2_ = g2;
    g2 = g'*g;

    if plevel; cost = 0.5 * (x'*(g-b)); end

  end

  info.iter = iter;
  info.prec = sqrt(g2);
  if ~isempty(dAd); info.curv = dAd/(d'*d); end

  return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nested function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  function [dd,t] = dogleg (dc, dn, delta)
  
  % [dd,t] = dogleg (dc, dn, delta)
  %
  % Find the step dd at the intersection of the sphere of radius delta
  % (>0) and the half-line dc -> dn. It is assumed that norm(dc) < min
  % (delta,norm(dn)).

  % Some variable (including the coefficients of the polynomial) are
  % named by two letters (aa, bb, cc, and dd) to avoid conflict with the
  % variables in the outer function (in particular b and d)

  dd = dn-dc;	% direction of move

  aa = dd'*dd;
  if aa == 0, dd = dc; return; end

  bb = dc'*dd;

  cc = dc'*dc - delta^2;
  if cc >= 0, dd = dc; return; end

  t = (sqrt(bb^2-aa*cc) - bb) / aa;
  dd = dc + t * dd;

  return

  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End of nested functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
