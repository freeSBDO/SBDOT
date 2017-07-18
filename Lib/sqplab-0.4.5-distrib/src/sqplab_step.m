function [d,lmqp,info] = sqplab_step (simul,x,lm,M,lb,ub,info,options,values)

%
% [d,lmqp,info] = sqplab_step (simul,x,lm,M,lb,ub,info,options,values)

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

  d         = [];
  lmqp      = [];
  info.flag = 0;

% Dimensions

  n  = length(info.g);
  nb = sum(min((lb(1:n)>-options.inf)+(ub(1:n)<options.inf),1));
  mi = length(info.ci);
  me = length(info.ce);
  ms = length(info.cs);

% Case without constraint

  if nb+mi+me+ms == 0
    if options.algo_method == values.newton     % M is the Hessian of f
%     d = -M\info.g;
      [d,rcond] = linsolve(M,-info.g);
      if (rcond < eps)
        info.flag = values.fail_on_ill_cond;
        if options.verbose; fprintf(options.fout,'\n\n### sqplab_step: linear system is singular to working precision\n'); end
        return
      end
    else                                        % M is the BFGS approximation of the INVERSE of the Hessian of f
      d = -(M*info.g);
    end
    return
  end

% Case without inequality constraint. Then there is just a linear system to solve.

  if nb+mi == 0

    % Case with state constraints

    if ms
      if me
        info.flag = values.fail_strange;
        if options.verbose
          fprintf(options.fout,'\n\n### sqplab_step: state and equality constraints cannot be considered simultaneously\n');
        end
        return
      end

      % restoration step
      info.nsimul(13) = info.nsimul(13) + 1;
      [outdic,r] = simul(13,x,-info.cs);
      if outdic; [info] = sqplab_badsimul (outdic,info,options,values); return; end
      if options.verbose >= 5; fprintf(options.fout,'\n  |r| = %9.3e',norm(r)); end

      % tangent step

      if n-ms
        switch options.algo_method
          case values.newton
            if ms       % M contains the reduced_L and L*r is desired
              info.nsimul(7) = info.nsimul(7) + 1;
              [outdic,s] = simul(7,x,lm,r);  % s = L*r
              if outdic; [info] = sqplab_badsimul (outdic,info,options,values); return; end
            else
              s = M*r;
            end
            info.nsimul(16) = info.nsimul(16) + 1;
            [outdic,s] = simul(16,x,info.g+s);   % s = Z_'*(g+L*r)
            if outdic; [info] = sqplab_badsimul (outdic,info,options,values); return; end
          case values.quasi_newton                      % M contains an approximation of L
            info.nsimul(16) = info.nsimul(16) + 1;
            [outdic,s] = simul(16,x,info.g+M*r); % s = Z_'*(g+M*r)
            if outdic; [info] = sqplab_badsimul (outdic,info,options,values); return; end
          case values.cheap_quasi_newton;               % M contains (an approximation of) the reduced_L
            info.nsimul(16) = info.nsimul(16) + 1;
            [outdic,s] = simul(16,x,info.g);     % s = Z_'*g
            if outdic; [info] = sqplab_badsimul (outdic,info,options,values); return; end
        end
        info.nsimul(15) = info.nsimul(15) + 1;
        [h,rcond] = linsolve(M,-s);              % h = - (Z_'*L*Z_)^(-1) * Z_'*(g+L*r)or(g)
        if (rcond < eps)
          info.flag = values.fail_on_ill_cond;
          if options.verbose; fprintf(options.fout,'\n\n### sqplab_step: linear system is singular to working precision\n'); end
          return
        end
        [outdic,t] = simul(15,x,h);              % t = - Z_ * (Z_'*L*Z_)^(-1) * Z_'*(g+L*r)or(g)
        if outdic; [info] = sqplab_badsimul (outdic,info,options,values); return; end
      else
        t = zeros(n,1);
      end
      if options.verbose >= 5; fprintf(options.fout,',  |t| = %9.3e',norm(t)); end

      % full step
      d = r + t;

      % multiplier
      if options.algo_method == values.newton;
        info.nsimul(7) = info.nsimul(7) + 1;
        [outdic,aux] = simul(7,x,lm,d);          % aux = L*d
        info.nsimul(14) = info.nsimul(14) + 1;
        [outdic,lm] = simul(14,x,-info.g-aux);   % lm = - A_' * (g+M*d)
      else      % in a quasi-Newton method, L is not available
        info.nsimul(14) = info.nsimul(14) + 1;
        [outdic,lm] = simul(14,x,-info.g);       % lm = - A_' * g
      end
      if outdic; [info] = sqplab_badsimul (outdic,info,options,values); return; end
      lmqp = zeros(n,1);
      lmqp(n+1:n+ms) = lm;

    % Case without state constraint

    else

      lastwarn('');             % make sure that the next 'lastwarn' will come from the linear solve below
      warning('off','all');     % prevent from printing warning messages (although warning messages can be catch by 'lastwarn')

      dlmp = [M, info.ae'; info.ae, zeros(me)] \ [-info.g; -info.ce];

      % see whether there has been a rounding error warning when solving the linear system
      if [strfind(lastwarn,'Matrix is close to singular or badly scaled'), ...
          strfind(lastwarn,'Matrix is singular to working precision')]
        info.flag = values.fail_on_ill_cond;
        if options.verbose; fprintf(options.fout,'\n\n### sqplab_step: linear system is singular to working precision\n'); end
        return
      end

% 'Linsolve' is currently not supported for sparse inputs
%     [dlmp,rcond] = linsolve([M, info.ae'; info.ae, zeros(me)] , [-info.g; -info.ce]);        % does not work for sparse system
%     if (rcond < eps)
%       info.flag = values.fail_on_ill_cond;
%       if options.verbose; fprintf(options.fout,'\n\n### sqplab_step: linear system is singular to working precision\n'); end
%       return
%     end

      d = dlmp(1:n);
      lmqp = zeros(n,1);
      lmqp(n+1:n+me) = dlmp(n+1:n+me);

    end
    return
  end

% Case with inequality constraints. Then use 'quadprog'.

  if ms
    info.flag = values.fail_strange;
    if options.verbose
      fprintf(options.fout,'\n\n### sqplab_step: state and inequality constraints cannot be considered simultaneously\n');
    end
    return
  end

  qp_options = optimset ('Display',    'off', ...
                         'Diagnostics','off', ...
                         'LargeScale', 'off');

  if mi
    I = find((lb(n+1:n+mi)>-options.inf) + (ub(n+1:n+mi)<options.inf)); % indices with a bound
    [d,tmp,qp_flag,tmp,ll] = ...
      quadprog (M,info.g,[info.ai(I,:);-info.ai(I,:)],[ub(n+I)-info.ci(I);info.ci(I)-lb(n+I)], ...
                info.ae,-info.ce,lb(1:n)-x,ub(1:n)-x,[],qp_options);
  else
    [d,tmp,qp_flag,tmp,ll] = ...
      quadprog (M,info.g,[],[],info.ae,-info.ce,lb(1:n)-x,ub(1:n)-x,[],qp_options);
  end

  if qp_flag == -2              % infeasible QP
    info.flag = values.fail_on_infeasible_QP;
    if options.verbose; fprintf(options.fout,'\n\n### sqplab_step: infeasible QP\n'); end
    return
  elseif qp_flag == -3          % unbounded QP
    info.flag = values.fail_on_unbounded_QP;
    if options.verbose; fprintf(options.fout,'\n\n### sqplab_step: unbounded QP\n'); end
    return
  elseif qp_flag ~= 1           % other failures
    info.flag = values.fail_strange;
    if options.verbose; fprintf(options.fout,'\n\n### sqplab_step: ''quadprog'' fails (exitflag = %0i)\n',qp_flag); end
    return
  end

  if mi
    nI = length(I);
%   lmqp = [ll.upper-ll.lower; ll.ineqlin(1:nI)-ll.ineqlin(nI+1:2*nI); ll.eqlin];
    lmqp = zeros(n+mi+me,1);
    lmqp(1:n) = ll.upper-ll.lower;
    lmqp(n+I) = ll.ineqlin(1:nI)-ll.ineqlin(nI+1:2*nI);
    if me
      lmqp(n+mi+1:n+mi+me) = ll.eqlin;
    end
  else
    lmqp = [ll.upper-ll.lower; ll.eqlin];
  end
  
return
