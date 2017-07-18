function [x,lm,info] = sqplab_loop (simul,n,nb,mi,me,ms,x,lm,lb,ub,info,options,values)

%
% [info] = sqplab_loop (simul,n,nb,mi,me,ms,x,lm,lb,ub,info,options,values)
%
% Realizes the optimization loop for the following algorithms:
% - Newton method,       with/without state constraints, with/without linesearch
% - quasi-Newton method,      without state constraints, with/without linesearch

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

  alpha           = [];
  sigma           = [];
  sigmab          = [];
  constrained_pbl = nb+mi+me+ms;
  null_step       = 0;

% Initial printing

  if options.verbose == 3
    fprintf(options.fout,'\n%s',values.dline);
    if options.algo_globalization == values.unit_stepsize
      fprintf(options.fout,'\niter simul      cost      ');
    else
      fprintf(options.fout,'\niter simul  stepsize      cost      ');
    end
    if nb+mi+me+ms
      fprintf(options.fout,'|grad Lag|  feasibility');
    else
      fprintf(options.fout,'|gradient|');
    end
    if (options.algo_method == values.quasi_newton) & constrained_pbl
      fprintf(options.fout,'  BFGS');
    end
  end

% Initialize the Hessian of the Lagrangian or its approximation

  switch options.algo_method
    case values.newton;
      if ms
        info.nsimul(6) = info.nsimul(6) + 1;
        [outdic,M] = simul(6,x,lm);
      else
        info.nsimul(5) = info.nsimul(5) + 1;
        [outdic,M] = simul(5,x,lm);
      end
      if outdic; [info] = sqplab_badsimul (outdic,info,options,values); return; end
    case values.quasi_newton
      if ms
        if options.verbose; fprintf(options.fout,'\n### sqplab_loop: unexpected state constraints\n\n'); end;
        info.flag = values.fail_strange;
        return
      else
        if ~constrained_pbl & (options.df1 > 0) & (info.f > 0)
          % Fletcher's scaling (expected decrease at the first iteration is options.df1*info.f)
          M = (2*options.df1*info.f/(info.g'*info.g))*eye(n);
        else
          M = eye(n);
        end
      end
    case values.cheap_quasi_newton
      % an optimal control problem with quasi-Newton Hessian approximations is treated by a reduced quasi-Newton algorithm
      if options.verbose; fprintf(options.fout,'\n### sqplab_loop: unexpected cheap quasi-Newton method\n\n'); end;
      info.flag = values.fail_strange;
      return
  end

%-----------------------------------------------------------------------
% The loop
%-----------------------------------------------------------------------

  while 1

  %--------------------
  % Stopping criterions
  %--------------------

    % Stop on counter

    if info.niter >= options.miter
      info.flag = values.stop_on_max_iter;
      return
    end
%   if info.nsimul >= options.msimul
%     info.flag = values.stop_on_max_simul;
%     return
%   end

    % Stop on convergence

    [feas,comp,info] = sqplab_optimality (simul,x,lm,lb,ub,info,options,values);
    if info.flag; return; end
    info.glagn = norm(info.glag,inf);
    info.feasn = norm(feas,inf);
    info.compl = norm(comp,inf);
    if (info.niter > 0) & (options.verbose >= 4)
      fprintf(options.fout,'\n\nOptimality:');
      if constrained_pbl
        fprintf(options.fout,'\n  |grad Lag|      = %12.5e',info.glagn);
        fprintf(options.fout,'\n  feasibility     = %12.5e',info.feasn);
        fprintf(options.fout,'\n  complementarity = %12.5e',info.compl);
      else
        fprintf(options.fout,' |grad f| = %12.5e',info.glagn);
      end
    end
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
      fprintf(options.fout,'\n%4i  %4i',info.niter,info.nsimul(2)+info.nsimul(4));
      if options.algo_globalization ~= values.unit_stepsize
        if info.niter > 1
          fprintf(options.fout,'  %8.2e',alpha);
        else
          fprintf(options.fout,'          ');
        end
      end
      fprintf(options.fout,'  %12.5e  ',info.f);
      if constrained_pbl
        fprintf(options.fout,'%10.4e  %11.5e',info.glagn,info.feasn);
      else
        fprintf(options.fout,'%10.4e',info.glagn);
      end
    end

    if options.verbose >= 4
      fprintf(options.fout,'\n%s',values.dline);
      fprintf(options.fout,'\niter %i,',info.niter);
      fprintf(options.fout,'  cost %12.5e',info.f);
      if constrained_pbl
        fprintf(options.fout,',  glagn %11.5e,  feas %11.5e',info.glagn,info.feasn);
        if nb+mi; fprintf(options.fout,',  compl %11.5e',info.compl); end
      else
        fprintf(options.fout,',  grad %11.5e',info.glagn);
      end
    end

  %--------------------
  % Step computation
  %--------------------

    if options.verbose >= 4; fprintf(options.fout,'\n\nQP solve'); end

    [d,lmqp,info] = sqplab_step (simul,x,lm,M,lb,ub,info,options,values);
    if info.flag; return; end

    if constrained_pbl; lmqpn = sqplab_dnorm (lmqp); end        % dual norm of the QP multiplier
  
    if options.verbose == 4;
      fprintf(options.fout,': |d|_2 = %9.3e',norm(d));
      if constrained_pbl; fprintf(options.fout,',  |lambda_QP| = %9.3e',lmqpn); end
    elseif options.verbose >= 5;
      fprintf(options.fout,',  |d|_2 = %9.3e',norm(d));
      if constrained_pbl; fprintf(options.fout,'\n  |lambda_QP| = %9.3e',lmqpn); end
    end

    % detect primal null step

    if norm(d,inf) <= 0%options.dxmin;
      null_step = null_step + 1;
      alpha = 1;                                % only useful for printing it
      if options.verbose >= 5
        if options.algo_globalization == values.linesearch;
          fprintf('\n\nLinesearch skipped, since small primal step');
        end
        if options.algo_method == values.quasi_newton
          fprintf('\n\nBFGS update skipped, since small primal step');
        end
      end
    end
    if null_step > values.max_null_steps;       % a primal null step cannot occur too often
      info.flag = values.fail_on_null_step;
      return
    end

  %--------------------
  % Globalization
  %--------------------

    % Globalization by linesearch **********************************************

    if (options.algo_globalization == values.linesearch) & ~null_step

      % do the linesearch if the step d is not too small; this can occur if x is almost optimal but not lm (then the QP solver
      % return an almost zero d and an almost correct lm)

      % save some information for a quasi-Newton update, before updating g; for constrained problems, ai, ae, and as cannot
      % still be used since the new multiplier is set after the linesearch and it is this one that intervenes in y

      if options.algo_method == values.quasi_newton;
        y = -info.g;
      end

      % initialization/update of the penalty parameter

      if constrained_pbl; [sigma,sigmab] = sqplab_sigma (sigma,sigmab,lmqpn,info,options); end

      % do the linesearch

      if isfield(options,'algo_descent') && options.algo_descent == values.wolfe
        [xp,alpha,info] = sqplab_wolfe (simul,x,d,lb,ub,info,options,values);
      else
        [xp,alpha,merit,info] = sqplab_armijo (simul,x,d,lb,ub,sigma,info,options,values);
      end
      if info.flag
        x = xp;
        if info.flag == values.stop_on_dxmin     % give a chance to a successful termination
          % update the multiplier
          if constrained_pbl; lm = lm+alpha*(lmqp-lm); end
          % call the simulator for computing g, ai, ae, and as at the new point
          info.nsimul(3) = info.nsimul(3) + 1;
          [outdic,tmp,tmp,tmp,tmp,info.g,info.ai,info.ae] = simul(3,x);
          if outdic; [info] = sqplab_badsimul (outdic,info,options,values); return; end
          % check whether convergence is reached
          [feas,comp,info] = sqplab_optimality (simul,x,lm,lb,ub,info,options,values);
          info.glagn = norm(info.glag,inf);
          info.feasn = norm(feas,inf);
          info.compl = norm(comp,inf);
          if (info.glagn <= options.tol(1)) & (info.feasn <= options.tol(2)) & (info.compl <= options.tol(3));
            info.flag = values.success;
          end
        end
        return
      end

      % update the multiplier lm

      if constrained_pbl; lm = lm + alpha*(lmqp-lm); end

% fprintf ('\n\n lower bound       d         upper bound   multiplier\n');
% for i = 1:n
%   if isempty(lb)
%     fprintf ('            ');
%   else
%     fprintf ('%12.5e',lb(i)-x(i));
%   end
%   fprintf ('  %12.5e',d(i));
%   if isempty(ub)
%     fprintf ('              ');
%   else
%     fprintf ('  %12.5e',ub(i)-x(i));
%   end
%   fprintf ('  %12.5e\n',lm(i));
% end
% fprintf (' lower bound       x         upper bound   multiplier\n');
% for i = 1:n
%   if isempty(lb)
%     fprintf ('            ');
%   else
%     fprintf ('%12.5e',lb(i));
%   end
%   fprintf ('  %12.5e',x(i));
%   if isempty(ub)
%     fprintf ('              ');
%   else
%     fprintf ('  %12.5e',ub(i));
%   end
%   fprintf ('  %12.5e\n',lm(i));
% end

      % save some information for a quasi-Newton update, before updating ai, ae, and as

      if options.algo_method == values.quasi_newton;
        s = xp - x;
        if mi; y = y - info.ai'*lm(n+1:n+mi); end
        if me; y = y - info.ae'*lm(n+mi+1:n+mi+me); end
        if ms
          info.nsimul(12) = info.nsimul(12) + 1;
          [outdic,astlm] = simul(12,x,lm(n+mi+me+1:n+mi+me+ms));      % astlm = as' * lm(...)
          if outdic; [info] = sqplab_badsimul (outdic,info,options,values); return; end
          y = y - astlm;
        end
      end

      % update x

      x = xp;

      % call the simulator for computing g, ai, and ae at the new point

      if ~isfield(options,'algo_descent') || options.algo_descent ~= values.wolfe
        info.nsimul(3) = info.nsimul(3) + 1;
        [outdic,tmp,tmp,tmp,tmp,info.g,info.ai,info.ae] = simul(3,x);
        if outdic; [info] = sqplab_badsimul (outdic,info,options,values); return; end
      end

    % Unit stepsize ************************************************************

    else

      x = x+d;
      lm = lmqp;

      % save some information for a quasi-Newton update, before updating ai and ae

      if (options.algo_method == values.quasi_newton) & ~null_step
        s = d;
        y = -info.g;
        if mi; y = y - info.ai'*lm(n+1:n+mi); end
        if me; y = y - info.ae'*lm(n+mi+1:n+mi+me); end
        if ms
          info.nsimul(12) = info.nsimul(12) + 1;
          [outdic,astlm] = simul(12,x,lm(n+mi+me+1:n+mi+me+ms));      % astlm = as' * lm(...)
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

    elseif ~null_step                                        % quasi-Newton methodif

      if options.verbose >= 4
        if constrained_pbl
          fprintf(options.fout,'\n\nBFGS update');
        else
          fprintf(options.fout,'\n\nBFGS inverse update');
        end
      end

      % update y

      y = y + info.g;
      if mi; y = y + info.ai'*lm(n+1:n+mi); end
      if me; y = y + info.ae'*lm(n+mi+1:n+mi+me); end
      if ms
        info.nsimul(12) = info.nsimul(12) + 1;
        [outdic,astlm] = simul(12,x,lm(n+mi+me+1:n+mi+me+ms));      % astlm = as' * lm(...)
        if outdic; [info] = sqplab_badsimul (outdic,info,options,values); return; end
        y = y + astlm;
      end

      % compute the BFGS approximation of the Hessian of the Lagrangian (with Powell corrections)

      first = 0;
      if info.niter == 1; first = 1; end
      if constrained_pbl
        [M,pc,info,values] = sqplab_bfgs (M,y,s,first,info,options,values);
      else
        [M,info] = sqplab_bfgs_inv (M,y,s,first,info,options,values);
      end
      if info.flag; return; end
      if (options.verbose == 3) & constrained_pbl
        fprintf(options.fout,'  %4.2f',pc);
      end

    end

  end

return
