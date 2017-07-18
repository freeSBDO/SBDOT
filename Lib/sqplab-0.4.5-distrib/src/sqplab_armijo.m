function [xp,alpha,merit,info] = sqplab_armijo (simul,x,d,lb,ub,sigma,info,options,values);

%
% [xp,alpha,merit,info] = sqplab_armijo (simul,x,d,lb,ub,sigma,info,options,values);
%
% This procedure initializes and/or updates the penalty parameter used
% in the merit function.
%
% On entry:
%   niter: iteration index (1 at the first iteration)
%   sigma: previous penalty parameter (if niter >= 2)
%   lmqpn: primal norm of the QP multiplier
%
% On return:

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

  info.flag = values.success;
  xp     = x;
  f0     = info.f;
  alpha  = [];
  merit  = [];

  w1  = 0.0001; % Armijo coeffficient
  isg = 0.1;    % interpolation safeguard (must be in (0,0.5)), the new alpha will be in [isg*t, (1-isg)*t]

% Evaluate the merit function and cshn=|c^#|

  [merit,cshn] = sqplab_merit (x,f0,info.ci,info.ce,info.cs,lb,ub,sigma);

% Slope is a negative upper bound on the directional derivative of the merit function

  if isempty(sigma)     % unconstrained problem
    slope = info.g'*d;
  else                  % constrained problem
    slope = info.g'*d - sigma*cshn;
  end

  if options.verbose > 4
    if isempty(sigma)     % unconstrained problem
      fprintf(options.fout,'\n\nLinesearch (Armijo):  f = %12.5e,  slope = %12.5e',merit,slope);
    else                  % constrained problem
      fprintf(options.fout,'\n\nLinesearch (Armijo):  merit = %12.5e,  slope = %12.5e',merit,slope);
    end
  end

  if slope >= 0
    info.flag = values.fail_on_ascent_dir;
    if options.verbose, fprintf(options.fout,'\n\n### sqplab_armijo: stop on positive slope\n'); end
    if options.verbose > 4
      fprintf(options.fout,'\n            g''*d  = %12.5e',info.g'*d);
      fprintf(options.fout,'\n            sigma = %12.5e',sigma);
      fprintf(options.fout,'\n            |c^#| = %12.5e',cshn);
      fprintf(options.fout,'\n            slope = %12.5e\n',slope);
    end
    return
  end

% Determine the stepsize alpha by backtracking linesearch

  if options.verbose > 4
    if isempty(sigma)     % unconstrained problem
      fprintf(options.fout,'\n   stepsize        f-f0         FD on f');
    else                  % constrained problem
      fprintf(options.fout,'\n   stepsize    meritp-merit   FD on merit     FD on f');
    end
  end

  alpha = 1;    % initial stepsize
  w1slope=w1*slope;
  iter_ls = 0;

  while 1

    % LS iteration

    iter_ls = iter_ls + 1;

    % new point

    xp=x+alpha*d;

    % stop if too small step-size

    if norm(xp-x,inf) < options.dxmin
      info.flag = values.stop_on_dxmin;
      if options.verbose
        fprintf(options.fout,'\n\n### sqplab_armijo: stop on dxmin\n');
        fprintf(options.fout,'\n            alpha      = %11.5e',alpha);
        fprintf(options.fout,'\n            |d|_inf    = %11.5e',norm(d,inf));
        fprintf(options.fout,'\n            |xp-x|_inf = %11.5e\n',norm(xp-x,inf));
      end
      return
    end

    % simulation at the new point

    info.nsimul(2) = info.nsimul(2) + 1;
    [outdic,info.f,info.ci,info.ce,info.cs] = simul(2,xp);

    if outdic
      if outdic == 1,   % out of implicit domain
        if options.verbose > 4, fprintf(options.fout,'\n  %10.4e  out of domain',alpha); end
        alpha = 0.5*alpha;
        continue;
      elseif outdic == 2,
        if options.verbose; fprintf(options.fout,'\n\n### sqplab_armijo: the simulator wants to stop\n'); end;
        info.flag = values.stop_on_simul;
        return
      else
        if options.verbose; fprintf(options.fout,'\n\n### sqplab_armijo: error with the simulator (outdic = %0i)\n',outdic); end;
        info.flag = values.fail_on_simul;
        return
      end
    else
      [meritp] = sqplab_merit (xp,info.f,info.ci,info.ce,info.cs,lb,ub,sigma); % new merit function value
      if isnan(meritp) || isinf(meritp)
        if options.verbose > 4, fprintf(options.fout,'\n  %10.4e  out of domain',alpha); end
        alpha = 0.5*alpha;
        continue;
      end
      if options.verbose > 4
        if isempty(sigma)     % unconstrained problem
          fprintf(options.fout,'\n  %10.4e  %13.6e  %12.5e',alpha,meritp-merit,(info.f-f0)/alpha);
        else                  % constrained problem
          fprintf(options.fout,'\n  %10.4e  %13.6e  %12.5e  %12.5e',alpha,meritp-merit,(meritp-merit)/alpha,(info.f-f0)/alpha);
        end
      end
      if (meritp <= merit + alpha*w1slope)
        if (meritp >= merit); info.flag = values.fail_on_non_decrease; end
        break;
      end

%     % detection d'erreur d'arrondi
%     if meritp-merit == 0
%       info.flag = 9;
%       if options.verbose > 4
%         fprintf(options.fout,'\n\n### sqplab_armijo: arret sur erreur d''arrondi (variation nulle de la fct de merite)\n');
%         fprintf(options.fout,'\n  alpha  = %12.5e',alpha);
%         fprintf(options.fout,'\n  |xp-x| = %12.5e\n',norm(xp-x,inf));
%         sqp_fin (simul, x, lambdaE, lambdaI, info.ce, info.ci, AE, AI, kkt, convergence, info.flag, options)
%       end
%       return
%     end

    end

    % quadratic interpolation (the quadratic model is t -> a*t^2 + b*t + c)

    a = (meritp-merit-slope*alpha)/alpha^2;
    alphamin = -slope/(2*a);
    if alphamin < isg*alpha
      alpha = isg*alpha;
    elseif alphamin > (1.-isg)*alpha
      alpha = (1-isg)*alpha;
    else
      alpha = alphamin;
    end

  end   % end of backtracking linesearch

return
