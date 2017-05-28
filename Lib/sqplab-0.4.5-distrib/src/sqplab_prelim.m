function [n,nb,mi,me,ms,x,lm,lb,ub,info,options,values] = sqplab_prelim (simul,x0,lm0,lb,ub,options);

% [n,nb,mi,me,ms,x,lm,lb,ub,info,options,values] = sqplab_prelim (simul,x0,lm0,lb,ub,options);
%
% This function realizes the following preliminary jobs:
% - set default output arguments
% - set options (default values if absent, numeric values for lexical options)
% - check the given options
% - get the possible 'values' of options
% - compute function values and deduce dimensions
% - compute an initial multiplier (if not given)
% - initial printings

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

%===============================================================================

% Set output arguments

  n		= 0;
  nb		= 0;
  mi		= 0;
  me		= 0;
  ms		= 0;
  x		= [];
  lm		= [];
  info.g	= [];
  info.ai	= [];
  info.ae	= [];
  info.hl	= [];
  info.niter    = 0;
  values	= [];

% Set a default value to an absent option, set a numeric value to a lexical option, and get the possible 'values' of options

  % check validity of the options only if some of them have been set by the user
  checkoptions = 1;
  if isempty(options); checkoptions = 0; end;

  % get the user options
  [info,options,values] = sqplab_options (info,options);
  if info.flag; return; end

  info.nsimul(1:values.nsimultype) = 0;

% Check the argument x0; deduce n

  x = x0;
  n = size(x,1);

  if size(x,2) ~= 1
    if options.verbose; fprintf(options.fout,'\n### sqplab: the initial x must be an n-vector\n\n'); end;
    info.flag = values.fail_on_argument;
    return
  end
  if n < 1
    if options.verbose; fprintf(options.fout,'\n### sqplab: the initial x must be an n-vector with n > 0\n\n'); end;
    info.flag = values.fail_on_argument;
    return
  end

% Compute f, ci, ce, cs, g, ai, and ae; deduce mi, me, and ms

  info.nsimul(4) = info.nsimul(4) + 1;
  [outdic,info.f,info.ci,info.ce,info.cs,info.g,info.ai,info.ae] = simul(4,x);
  if outdic == 1,
    if options.verbose; fprintf(options.fout,'\n### sqplab: initial point x is out of domain\n\n'); end;
    info.flag = values.fail_on_simul;
    return;
  end
  if isnan(info.f)
    if options.verbose; fprintf(options.fout,'\n### sqplab: f is NaN at the initial point x\n\n'); end;
    info.flag = values.fail_on_simul;
    return;
  end
  if outdic; [info] = sqplab_badsimul (outdic,info,options,values); return; end

  mi = size(info.ci,1);
  if mi > 0
    if size(info.ci,2) ~= 1
      if options.verbose; fprintf(options.fout,'\n### sqplab: the computed ci must be a column vector\n\n'); end;
      info.flag = values.fail_on_simul;
      return
    end
    if any(size(info.ai) ~= [mi n])
      if options.verbose
        fprintf(options.fout,'\n### sqplab: the computed ai has a wrong size, (%0i,%0i) instead of (%0i,%0i)\n\n', ...
                size(info.ai),mi,n);
      end;
      info.flag = values.fail_on_simul;
      return
    end
  end

  me = size(info.ce,1);
  if me > 0
    if size(info.ce,2) ~= 1
      if options.verbose; fprintf(options.fout,'\n### sqplab: the computed ce must be a column vector\n\n'); end;
      info.flag = values.fail_on_simul;
      return
    end
    if any(size(info.ae) ~= [me n])
      if options.verbose
        fprintf(options.fout,'\n### sqplab: the computed ae has a wrong size, (%0i,%0i) instead of (%0i,%0i)\n\n', ...
                size(info.ae),me,n);
      end;
      info.flag = values.fail_on_simul;
      return
    end
  end

  ms = size(info.cs,1);
  if ms > 0
    if size(info.cs,2) ~= 1
      if options.verbose; fprintf(options.fout,'\n### sqplab: the computed cs must be a column vector\n\n'); end;
      info.flag = values.fail_on_simul;
      return
    end
  end

  if any(size(info.g) ~= [n 1])
    if options.verbose
      fprintf(options.fout,'\n### sqplab: the computed gradient g has a wrong size, (%0i,%0i) instead of (%0i,1)\n\n', ...
              size(info.g),n);
    end;
    info.flag = values.fail_on_simul;
    return
  end

% Compute the number of bounds

  if isempty(lb); lb = -options.inf*ones(n+mi,1); end
  if isempty(ub); ub =  options.inf*ones(n+mi,1); end
  nb_lo = sum(lb(1:n)>-options.inf);
  nb_up = sum(ub(1:n)< options.inf);
  nb_lu = sum(min((lb(1:n)>-options.inf).*(ub(1:n)< options.inf),1));
  nb    = sum(min((lb(1:n)>-options.inf)+(ub(1:n)< options.inf),1));

% Initial printing (1)

  if options.verbose >= 2
    values.dline = '----------------------------------------';
    values.dline = strcat(values.dline,values.dline);        % 80 dashes
    values.eline = '========================================';
    values.eline = strcat(values.eline,values.eline);        % 80 '=' characters
    values.sline = '****************************************';
    values.sline = strcat(values.sline,values.sline);        % 80 '*' characters
    fprintf(options.fout,'%s',values.sline);
    fprintf(options.fout,'\nSQPLAB optimization solver (Version 0.4.4, February 2009, entry point)\n');
    if isa(simul,'function_handle')
      simul_name = func2str(simul);
    else
      simul_name = simul;
    end
    fprintf(options.fout,'  simulator name: "%s"\n',simul_name);
    fprintf(options.fout,'  dimensions:\n');
    fprintf(options.fout,'  . variables (n):               %4i\n',n);
    if nb > 0
      fprintf(options.fout,'  . bounds on variables (nb):    %4i (%0i lower, %0i double, %0i upper)\n',nb,nb_lo,nb_lu,nb_up);
    end
    if mi > 0; fprintf(options.fout,'  . inequality constraints (mi): %4i\n',mi); end
    if me > 0; fprintf(options.fout,'  . equality constraints (me):   %4i\n',me); end
    if ms > 0; fprintf(options.fout,'  . state constraints (ms):      %4i\n',ms); end
    fprintf(options.fout,'  required tolerances for optimality:\n');
    if nb+mi+me+ms
      fprintf(options.fout,'  . gradient of the Lagrangian      %8.2e\n',options.tol(1));
      fprintf(options.fout,'  . feasibility                     %8.2e\n',options.tol(2));
      if nb+mi; fprintf(options.fout,'  . complementarity                 %8.2e\n',options.tol(3)); end
    else
      fprintf(options.fout,'  . gradient of the cost function   %8.2e\n',options.tol(1));
    end
    fprintf(options.fout,'  counters:\n');
    fprintf(options.fout,'  . max iterations                  %4i\n',options.miter);
%   fprintf(options.fout,'  . max simulations                 %4i\n',options.msimul);
    fprintf(options.fout,'  algorithm:\n');
    switch options.algo_method
      case values.newton;             fprintf(options.fout,'  . Newton method\n');
      case values.quasi_newton;       fprintf(options.fout,'  . quasi-Newton method\n');
      case values.cheap_quasi_newton; fprintf(options.fout,'  . cheap quasi-Newton method\n');
    end
    switch options.algo_globalization
      case values.unit_stepsize;
        fprintf(options.fout,'  . unit step-size\n');
      case values.linesearch;
        if options.algo_method == values.newton
          fprintf(options.fout,'  . globalization by Armijo''s linesearch\n');
        elseif options.algo_method == values.quasi_newton
          if isfield(options,'algo_descent')
            if options.algo_descent == values.powell
              fprintf(options.fout,'  . globalization by Armijo''s linesearch (descent ensured by Powell corrections)\n');
            elseif options.algo_descent == values.wolfe
              if nb+mi+me+ms == 0
                fprintf(options.fout,'  . globalization by Wolfe''s linesearch\n');
              elseif ms > 0
                fprintf(options.fout,'  . globalization by piecewise linesearch\n');
              end
            end
          else
            fprintf(options.fout,'  . globalization by Armijo''s linesearch\n');
          end
        end
      case values.trust_regions;
        fprintf(options.fout,'  . globalization by trust regions\n');
    end
    fprintf(options.fout,'  various input/initial values:\n');
    if (options.algo_method == values.quasi_newton) & (nb+mi+me+ms == 0) & (options.df1 > 0) & (info.f > 0)
      fprintf(options.fout,'  . expected initial decrease       %8.2e\n',options.df1*info.f);
    end
    if nb+mi; fprintf(options.fout,'  . infinite bound threshold        %8.2e\n',options.inf); end
    fprintf(options.fout,'  . |x|_2                           %8.2e\n',norm(x));
  end

% Compute an initial multiplier if not given (takes a while); info.ci must be known

  if (nb+mi+me+ms)
    if isempty(lm0)
      [lm,info] = sqplab_lsmult (simul,x,ms,lb,ub,info,options,values);
      if info.flag; return; end
      if options.verbose >= 2
        fprintf(options.fout,'  . |lm|_2                          %8.2e (default: least-squares value)\n',norm(lm));
      end
    else
      lm = lm0;
      if options.verbose >= 2
        fprintf(options.fout,'  . |lm|_2                          %8.2e\n',norm(lm));
      end
    end
  end

% Initial optimality

  [feas,compl,info] = sqplab_optimality (simul,x,lm,lb,ub,info,options,values);
  if info.flag; return; end

% Initial printing (2)

  if options.verbose >= 2
    fprintf(options.fout,'  . |g|_inf                         %8.2e',norm(info.g,inf));
    if nb+mi+me+ms; fprintf(options.fout,'\n  . |glag|_inf                      %8.2e',norm(info.glag,inf)); end
    if nb; fprintf(options.fout,'\n  . |x^#|_inf                       %8.2e',norm(feas(1:n),inf)); end
    if mi; fprintf(options.fout,'\n  . |ci^#|_inf                      %8.2e',norm(feas(n+1:n+mi),inf)); end
    if me; fprintf(options.fout,'\n  . |ce|_inf                        %8.2e',norm(feas(n+mi+1:n+mi+me),inf)); end
    if ms; fprintf(options.fout,'\n  . |cs|_inf                        %8.2e',norm(feas(n+mi+me+1:n+mi+me+ms),inf)); end
    if nb+mi; fprintf(options.fout,'\n  . |complementarity|_inf           %8.2e',norm(compl,inf)); end
    fprintf(options.fout,'\n  tunings:');
    fprintf(options.fout,'\n  . printing level                  %0i',options.verbose);
  end

% Check the options

  [info,options] = sqplab_checkoptions (nb,mi,me,ms,info,options,values);
  if info.flag; return; end

return
