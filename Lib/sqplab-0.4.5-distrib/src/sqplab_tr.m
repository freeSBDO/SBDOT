function [x,lm,info] = sqplab_tr (simul,n,nb,mi,me,x,lm,lb,ub,info,options,values)

%
% [info] = sqplab_tr (simul,n,nb,mi,me,x,lm,lb,ub,info,options,values)
%
% Realizes the optimization loop for the following algorithms:
% - Newton/quasi-Newton method
% - without state constraints
% - with trust regions.

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

  delta    = 1;         % inital trust radius
  xi       = 0.8;       % trust radius contrictor (must be in (0,1))
  rho      = 0.3;       % it is imposed that pred/vred >= rho*sigmab (must be in (0,1))

  sigma    = 1;         % initial penalty parameter

  omega1   = 1.e-4;     % if ared/pred >= omega1, accept the step
  omega2   = 0.3;       % if ared/pred in [omega2,omega3[, multiply delta by tau2
  omega3   = 0.9;       % if ared/pred >= omega3, multiply delta by tau3
  tau1     = 0.5;       % trust radius reduction factor if out of domain
  tau2     = 2;         % good trust radius augmentation factor when active and concordance is >= omega2
  tau3     = 5;         % extra trust radius augmentation factor when active and concordance is >= omega3

  constrained_pbl = me;
  null_step       = 0;

  plevel_r = 0;         % printing level for the restoration step (0; nothing, >0: something)
  if options.verbose >= 5; plevel_r = 1; end
  plevel_t = 0;         % printing level for the tangent step (0; nothing, >0: something)
  if options.verbose >= 5; plevel_t = 1; end

% Initial printing

  if options.verbose == 3
    fprintf(options.fout,'\n%s',values.dline);
    fprintf(options.fout,'\niter simul  stepsize      cost      ');
    if nb+mi+me
      fprintf(options.fout,'|grad Lag|  feasibility');
    else
      fprintf(options.fout,'gradient');
    end
    if options.algo_method == values.quasi_newton
      fprintf(options.fout,'  BFGS');
    end
  end

% Initialize the Hessian of the Lagrangian or its approximation

  switch options.algo_method
    case values.newton;
      info.nsimul(5) = info.nsimul(5) + 1;
      [outdic,M] = simul(5,x,lm);
      if outdic; [info] = sqplab_badsimul (outdic,info,options,values); return; end
    case values.quasi_newton
      M = eye(n);
  end

% The loop

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
      if info.niter > 1
%       fprintf(options.fout,'  %8.2e',alpha);
      else
        fprintf(options.fout,'          ');
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
  % Globalization
  %--------------------
      
    iter_tr = 0;                % trust region iteration counter
    f0      = info.f;           % memorize f at the current iterate, useful in the sufficient decrease condition
    ce0     = info.ce;          % memorize ce at the current iterate in case of step rejection
    ce0n    = norm(ce0);
    merit0  = f0 + sigma*ce0n;  % inital value of the merit function, for the given sigma
    prec_r  = options.tol(2)/10;% initial precision for the restoration problem
    prec_t  = options.tol(1)/10;% initial precision for the tangent problem

    radius_has_been_rejected = false;

    if options.verbose >= 4; fprintf(options.fout,'\n\nStep computation: merit = %12.5e',merit0); end
    if options.verbose == 4
%     fprintf(options.fout,'\n  xxxxxxxx  xxxxxxx  xxxxxxx  xxxxxxx  xxxxxxx  xxxxxxxxx');
      fprintf(options.fout,'\n   radius     |r|      |t|      |s|     sigma  concordance');
    end

    while 1     % trust region loop (exited when a step has been accepted)

      iter_tr = iter_tr + 1;

      if options.verbose >= 5
        fprintf(options.fout,'\n  Trust radius = %8.2e\n  Restoration step',delta);
      end

      % Restoration step computation (computed by truncated CG)

      delta_r = xi*delta;

      if (iter_tr == 1) | (norm_r > delta_r) | (info_r.prec > prec_r)   % no need to recompute the restoration step otherwise

        [r,info_r] = sqplab_tcg (info.ae'*info.ae,-info.ae'*info.ce,delta_r,20*me,prec_r,plevel_r,options.fout);
        norm2_r = r'*r;
        norm_r = sqrt(norm2_r);
        rpred = norm(info.ce)-norm(info.ce+info.ae*r);
        if rpred < 0
          if options.verbose; fprintf(options.fout,'\n\n### sqplab_tr: rpred = %9.2e should not be negative\n',rpred); end;
          info.flag = values.fail_strange;
          return
        end
        active_r = (info_r.flag == 1) | (info_r.flag == 2);

        if options.verbose >= 5;
          switch info_r.flag
            case -1
              fprintf(options.fout,'\n    max of %0i iterations reached',20*me);
            case 0
              fprintf(options.fout,'\n    precision is less than required tolerance %8.2e',prec_r);
            case 1
              fprintf(options.fout,'\n    TR boundary is reached');
            case 2
              fprintf(options.fout,'\n    negative curvature direction encountered');
          end
          fprintf(options.fout,'\n    |r|   = %8.2e',norm_r);
          fprintf(options.fout,'\n    rpred = %8.2e',rpred);
        end

        new_r = true;

      else

        if options.verbose >= 5; fprintf(options.fout,': unchanged'); end

        active_r = false;
        new_r = false;

      end

      % Tangent step computation

      if options.verbose >= 5; fprintf(options.fout,'\n  Tangent step'); end

      if iter_tr == 1
        Z_ = null(full(info.ae));
        M_t = Z_'*M*Z_;
      end
      if new_r
        g_t = Z_'*(info.g+M*r);
      end
      delta_t = sqrt(delta^2-norm2_r);
      [u,info_t] = sqplab_tcg (M_t,-g_t,delta_t,20*(n-me),prec_t,plevel_t,options.fout);
      t = Z_*u;
      active_t = (info_t.flag == 1) | (info_t.flag == 2);

      if options.verbose >= 5;
        switch info_t.flag
          case -1
            fprintf(options.fout,'\n    max of %0i iterations reached',20*(n-me));
          case 0
            fprintf(options.fout,'\n    precision is less than required tolerance %8.2e',prec_t);
          case 1
            fprintf(options.fout,'\n    TR boundary is reached');
          case 2
            fprintf(options.fout,'\n    negative curvature direction encountered');
        end
        fprintf(options.fout,'\n    |t| = %8.2e',norm(t));
      end

      % Full step computation

      s = r+t;
      norm_s = norm(s);
      if options.verbose >= 5
        fprintf(options.fout,'\n  Full step:\n    |s| = %8.2e',norm_s);
      end
      if norm_s == 0
        prec_r = prec_r/2;
        prec_t = prec_t/2;
        if options.verbose >= 4; fprintf(options.fout,'\n  New step computation with a more stringent precision'); end
        if options.verbose >= 5, fprintf(options.fout,'\n  ----------',ratio); end
        continue
      end

      % Penalty parameter

      qcost = info.g'*s+0.5*(s'*M*s);
      if rpred == 0
        sigmab = 0;
      else
        sigmab = qcost/((1-rho)*rpred);
      end
      if sigma < sigmab
        sigma = max(sigmab,1.5*sigma);
        merit0 = f0 + sigma*ce0n;       % re-evaluate the merit function at x, since sigma has changed
      end
      if options.verbose >= 5
        fprintf(options.fout,'\n  Penalty parameter = %8.2e (threshold %8.2e)',sigma,sigmab);
      end

      % Simulation at the new point

      xp = x + s;

      info.nsimul(2) = info.nsimul(2) + 1;
      [outdic,info.f,info.ci,info.ce,info.cs] = simul(2,xp);

      % Step validation

      if outdic
        if outdic == 1,         % out of an implicit domain
          if options.verbose >= 5; fprintf(options.fout,'\n  Step rejected (out of an implicit domain)'); end
        elseif outdic == 2,     % the simulator wants to stop
          if options.verbose; fprintf(options.fout,'\n\n### sqplab_tr: the simulator wants to stop\n'); end;
          info.flag = values.stop_on_simul;
          return
        else                    % unexpected
          if options.verbose; fprintf(options.fout,'\n\n### sqplab_tr: error in the simulator (outdic = %0i)\n',outdic); end
          info.flag = values.fail_on_simul;
          return
        end
      else
        merit = info.f+sigma*norm(info.ce);
        if options.verbose >= 5; fprintf(options.fout,'\n  Merit function: %15.8e -> %15.8e',merit0,merit); end
        ared = merit0 - merit;
        pred = - qcost + sigma*rpred;
        if pred <= 0            % should not occur, since here s ~= 0
          if options.verbose; fprintf(options.fout,'\n\n### sqplab_tr: pred = %9.2e should be positive\n',pred); end;
          info.flag = values.fail_strange;
          return
        end
        ratio = ared/pred;
        if options.verbose == 4
          fprintf(options.fout,'\n  %8.2e  %7.1e  %7.1e  %7.1e  %7.1e  %9.2e',delta,norm_r,norm(t),norm_s,sigma,ratio);
        end
        if (ratio >= omega1)            % accept the step
          if options.verbose >= 5
            fprintf(options.fout,'\n  Step accepted (concordance = %9.2e; ared = %9.2e, pred = %9.2e)',ratio,ared,pred);
          end
          if (merit >= merit0);
            info.flag = values.fail_on_non_decrease;
            return
          end
          x = xp;                                                               % new primal variable
          [lm,info] = sqplab_lsmult (simul,x,0,lb,ub,info,options,values);      % new multiplier
          if ~radius_has_been_rejected & (active_r | active_t)
            if ratio >= omega3
              delta = delta*tau3;
            elseif ratio >= omega2
              delta = delta*tau2;
            end
          end
          break;
        end
        if options.verbose >= 5
          fprintf(options.fout,'\n  Step rejected (concordance = %9.2e; ared = %9.2e, pred = %9.2e)',ratio,ared,pred);
        end
      end

      % Step rejection

      radius_has_been_rejected = true;

      if options.verbose >= 5, fprintf(options.fout,'\n  ----------',ratio); end
      info.ce = ce0;    % recover ce at the current iterate
      delta = tau1*norm_s;

    end  % of trust region loop

  %--------------------
  % Compute the derivatives at the new point
  %--------------------

    info.nsimul(3) = info.nsimul(3) + 1;
    [outdic,tmp,tmp,tmp,tmp,info.g,info.ai,info.ae] = simul(3,x);
    if outdic; [info] = sqplab_badsimul (outdic,info,options,values); return; end

  %--------------------
  % Hessian of the Lagrangian or its BFGS approximation
  %--------------------

    if options.algo_method == values.newton;    % Newton-like method

      % compute the Hessian of the Lagrangian

      info.nsimul(5) = info.nsimul(5) + 1;
      [outdic,M] = simul(5,x,lm);
      if outdic; [info] = sqplab_badsimul (outdic,info,options,values); return; end

    elseif ~null_step                           % quasi-Newton method

      if options.verbose >= 4
        if constrained_pbl
          fprintf(options.fout,'\n\nBFGS update');
        else
          fprintf(options.fout,'\n\nBFGS inverse update');
        end
      end

      % update y with the data at the previous point

      y = -info.g;
      if me; y = y - info.ae'*lm(n+mi+1:n+mi+me); end

      % call the simulator for computing g, ai, and ae at the new point

      info.nsimul(3) = info.nsimul(3) + 1;
      [outdic,tmp,tmp,tmp,tmp,info.g,info.ai,info.ae] = simul(3,x);
      if outdic; [info] = sqplab_badsimul (outdic,info,options,values); return; end

      % update y with the data at the new point

      y = y + info.g;
      if me; y = y + info.ae'*lm(n+mi+1:n+mi+me); end

      % compute the BFGS approximation of the Hessian of the Lagrangian (with Powell corrections)

      first = 0;
      if info.niter == 1; first = 1; end
      [M,pc,info,values] = sqplab_bfgs (M,y,s,first,info,options,values);
      if info.flag; return; end
      if options.verbose == 3
        fprintf(options.fout,'  %4.2f',pc);
      end

    end

  end  % of iteration loop

return
