function [] = sqplab_rqn (simul,n,ms,x,lm,lb,ub,info,options,values)

%
% [] = sqplab_rqn (simul,n,ms,x,lm,lb,ub,info,options,values)

% Initialize the (reduced) Hessian of the Lagrangian approximation

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

  M = eye(n-ms);

%===============================================================================
% Iteration loop
%===============================================================================

% Initialization

  sigma      = [];
  sigmab     = [];

% Initial printing

  if options.verbose == 3
    fprintf(options.fout,'\n%s',values.dline);
    fprintf(options.fout,'\niter simul      cost      ');
    if nb+mi+me+ms
      fprintf(options.fout,'|grad Lag|  feasibility');
    else
      fprintf(options.fout,'gradient');
    end
  end

% The loop

  while 1

  %--------------------
  % Stopping criterions
  %--------------------

    % Stop on counter

    if info.niter >= options.miter
      info.flag = values.stop_on_max_iter;
      break
    end
%   if info.nsimul >= options.msimul
%     info.flag = values.stop_on_max_simul;
%     break
%   end

    % Stop on convergence

    [feas,comp,info] = sqplab_optimality (simul,x,lm,[],[],lb,ub,info,options,values);
    if info.flag; return; end
    info.glagn = norm(info.glag,inf);
    info.feasn = norm(feas,inf);
    info.compl = norm(comp,inf);
    if (info.glagn <= options.tol(1)) & (info.feasn <= options.tol(2)) & (info.compl <= options.tol(3))
      info.flag = values.success;
      return
    end

  %--------------------
  % Update the iteration counter and call the simulator with indic=1
  %--------------------

    info.niter = info.niter + 1;
    info.nsimul(1) = info.nsimul(1) + 1;
    [outdic] = simul(1,x,lm);
    if outdic; [info] = sqplab_badsimul (outdic,info,options,values); return; end

    if options.verbose == 3
      fprintf(options.fout,'\n%4i  %12.5e  ',info.niter,info.f);
      fprintf(options.fout,'%10.4e  %11.5e',info.glagn,info.feasn);
    end

    if options.verbose >= 4
      fprintf(options.fout,'\n%s',values.dline);
      fprintf(options.fout,'\niter %i,',info.niter);
      fprintf(options.fout,'  cost %12.5e',info.f);
      fprintf(options.fout,',  glagn %11.5e,  feas %11.5e',info.glagn,info.feasn);
    end

return

  %--------------------
  % Step computation
  %--------------------

    if options.verbose >= 4; fprintf(options.fout,'\n\nQP solve'); end

    [d,lmqp,info] = sqplab_step (simul,x,lm,M,lb,ub,info,options,values);
    if info.flag; break; end

    lmqpn = sqplab_dnorm (lmqp);  % dual norm of the QP multiplier
  
    if options.verbose == 4;
      fprintf(options.fout,': |d|_2 = %9.3e',norm(d));
      fprintf(options.fout,',  |lambda_QP| = %9.3e',lmqpn);
    elseif options.verbose >= 5;
      fprintf(options.fout,',  |d|_2 = %9.3e',norm(d));
      fprintf(options.fout,'\n  |lambda_QP| = %9.3e',lmqpn);
    end

  %--------------------
  % Globalization
  %--------------------

    % Globalization by linesearch **********************************************

    if options.algo_globalization == values.linesearch;

      % initialization/update of the penalty parameter

      [sigma,sigmab] = sqplab_sigma (sigma,sigmab,lmqpn,info,options);
  
      % do the linesearch

      [xp,alpha,merit,info] = sqplab_armijo (simul,x,d,lb,ub,sigma,info,options,values);
      if info.flag
        x = xp;
        if info.flag == values.stop_on_dxmin     % give a chance to a successful termination
          % update the multiplier
          lm = lm+alpha*(lmqp-lm);
          % call the simulator for computing g, ai, ae, and as at the new point
          info.nsimul(3) = info.nsimul(3) + 1;
          [outdic,tmp,tmp,tmp,tmp,info.g,info.ai,info.ae] = simul(3,x);
          if outdic; [info] = sqplab_badsimul (outdic,info,options,values); return; end
          % check whether convergence is reached
          [feas,comp,info] = sqplab_optimality (simul,x,lm,lb,ub,info,options,values);
          if info.flag; return; end
          info.glagn = norm(info.glag,inf);
          info.feasn = norm(feas,inf);
          info.compl = norm(comp,inf);
          if (info.glagn <= options.tol(1)) & (info.feasn <= options.tol(2)) & (info.compl <= options.tol(3));
            info.flag = values.success;
          end
        end
        break
      end

      % update the multiplier lm

      lm = lm + alpha*(lmqp-lm);

      % save some information for a quasi-Newton update, before updating ai and ae

      if options.algo_method == values.quasi_newton;
        s = xp - x;
        y = -info.g;
        if ms
          info.nsimul(12) = info.nsimul(12) + 1;
          [outdic,astlm] = simul(12,x,lm(n+1:n+ms));      % astlm = as' * lm(...)
          if outdic; [info] = sqplab_badsimul (outdic,info,options,values); return; end
          y = y - astlm;
        end
      end

      % update x

      x = xp;

      % call the simulator for computing g, ai, and ae at the new point

      info.nsimul(3) = info.nsimul(3) + 1;
      [outdic,tmp,tmp,tmp,tmp,info.g,info.ai,info.ae] = simul(3,x);
      if outdic; [info] = sqplab_badsimul (outdic,info,options,values); return; end

    % Unit stepsize ************************************************************

    else

      x = x+d;
      lm = lmqp;

      % save some information for a quasi-Newton update, before updating ai and ae

      if options.algo_method == values.quasi_newton;
        s = d;
        y = -info.g;
        if ms
          info.nsimul(12) = info.nsimul(12) + 1;
          [outdic,astlm] = simul(12,x,lm(n+1:n+ms));      % astlm = as' * lm(...)
          if outdic; [info] = sqplab_badsimul (outdic,info,options,values); return; end
          y = y - astlm;
        end
      end

      % call the simulator for computing f, ci, ce, cs, g, ai, and ae at the new point

      info.nsimul(4) = info.nsimul(4) + 1;
      [outdic,info.f,info.ci,info.ce,info.cs,info.g,info.ai,info.ae] = simul(4,x);
      if outdic; [info] = sqplab_badsimul (outdic,info,options,values); return; end

    end

  %--------------------
  % (reduced) Hessian of the Lagrangian or its BFGS approximation
  %--------------------

    if options.algo_method == values.newton;    % Newton-like method

      % compute the (reduced) Hessian of the Lagrangian

      if ms
        info.nsimul(6) = info.nsimul(6) + 1;
        [outdic,M] = simul(6,x,lm);
      else
        info.nsimul(5) = info.nsimul(5) + 1;
        [outdic,M] = simul(5,x,lm);
      end
      if outdic; [info] = sqplab_badsimul (outdic,info,options,values); return; end

    else                                        % quasi-Newton method

      if options.verbose >= 4; fprintf(options.fout,'\n\nBFGS update'); end

      % update y

      y = y + info.g;
      if ms
        info.nsimul(12) = info.nsimul(12) + 1;
        [outdic,astlm] = simul(12,x,lm(n+1:n+ms));      % astlm = as' * lm(...)
        if outdic; [info] = sqplab_badsimul (outdic,info,options,values); return; end
        y = y + astlm;
      end

      % compute the BFGS approximation of the Hessian of the Lagrangian (with Powell corrections)

      first = 0;
      if info.niter == 1; first = 1; end
      [M,pc,info,values] = sqplab_bfgs (M,y,s,first,info,options,values);
      if info.flag; break; end

    end

  end

%===============================================================================
% Conclusion
%===============================================================================

  sqplab_finish (0,0,0,ms,info,options,values)

return
