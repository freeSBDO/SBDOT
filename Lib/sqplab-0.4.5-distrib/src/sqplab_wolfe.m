function [x,alpha,info] = sqplab_wolfe (simul,x0,d,lb,ub,info,options,values);

%
% [x,alpha,info] = sqplab_wolfe (simul,x0,d,lb,ub,info,options,values);
%
%
% On entry:
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

  w1  = 1.e-5;  % Armijo coeffficient
  w2  = 0.999;  % Wolfe coefficient
  isg = 0.01;   % interpolation safeguard (must be in (0,0.5)), the new t will be in [(1-isg)*tm+isg*tp, isg*tm+(1-isg)*tp]
  esg = 2;      % extrapolation safeguard (must be in > 1), the new t will be in [esg*tm, inf[ (esg is *2 each time it is used)

  max_ls = 40;  % max stepsize trials
  max_ip = 10;  % max interpolation, after do dichotomy

  f0        = info.f;
  alpham    = 0;                % LHS of the interval where the stepsize is searched
  fm        = f0;
  gm        = info.g'*d;
  alphap    = inf;              % RHS of the interval where the stepsize is searched
  fp        = [];
  info.flag = values.success;

  x         = [];
% info.f    = [];
% info.g    = [];
  alpha     = [];

% Slope is a negative upper bound on the directional derivative of the cost function

  g0 = gm;      % initial slope

  if options.verbose > 4; fprintf(options.fout,'\n\nLinesearch (Wolfe):  f = %12.5e,  slope = %12.5e',f0,g0); end

  if g0 >= 0
    info.flag = values.fail_on_ascent_dir;
    x = x0;
    if options.verbose, fprintf(options.fout,'\n\n### sqplab: stop on positive slope = %11.5e\n',g0); end
    return
  end

% Determine the stepsize alpha by the Wolfe linesearch

  if options.verbose > 4; fprintf(options.fout,'\n    stepsize       f-f0        slope       FD on f'); end

  alpha = 1;    % initial stepsize
  w1s0 = w1*g0;
  w2s0 = w2*g0;
  iter_ls = 0;
  ip = 0;

  while 1

    % LS iteration

    iter_ls = iter_ls + 1;
    if iter_ls > max_ls
      info.flag = values.fail_on_max_ls_iter;
      if options.verbose, fprintf(options.fout,'\n\n### sqplab: too many stepsize trials\n',g0); end
      return
    end

    % new point

    x = x0+alpha*d;

    % stop if too small step-size

    if norm(x-x0,inf) < options.dxmin
      info.flag = values.stop_on_dxmin;
      if options.verbose
        fprintf(options.fout,'\n\n### sqplab: stop on dxmin\n');
        fprintf(options.fout,'\n            alpha  = %11.5e',alpha);
        fprintf(options.fout,'\n            |d|    = %11.5e',norm(d,inf));
        fprintf(options.fout,'\n            |x-x0| = %11.5e\n',norm(x-x0,inf));
      end
      return
    end

    % simulation at the new point

    info.nsimul(4) = info.nsimul(4) + 1;
    [outdic,info.f,aux,aux,aux,info.g,aux,aux] = simul(4,x);

    if outdic
      if outdic == 1,   % out of implicit domain
        if options.verbose > 4, fprintf(options.fout,'\n   %10.4e]  out of domain',alpha); end
        alphap = alpha;
        alpha = 0.5*alpha;
        max_ls = max_ls+1;
        continue;
      elseif outdic == 2,
        if options.verbose; fprintf(options.fout,'\n### sqplab: the simulator wants to stop\n\n'); end;
        info.flag = values.stop_on_simul;
        return
      else
        if options.verbose; fprintf(options.fout,'\n### sqplab: error with the simulator (outdic = %0i)\n\n',outdic); end;
        info.flag = values.fail_on_simul;
        return
      end
    end

%   info.nsimul = info.nsimul+1;

    % check the stepsize

    gd = info.g'*d;
    if (info.f <= f0 + alpha*w1s0)
      if (gd >= w2s0)           % a Wolfe stepsize has been found
        if options.verbose > 4
          fprintf(options.fout,'\n   %10.4e   %10.3e  %10.3e  %12.5e',alpha,info.f-f0,gd,(info.f-f0)/alpha);
        end
        break;
      else                      % the stepsize is too small
        if options.verbose > 4
          fprintf(options.fout,'\n  [%10.4e   %10.3e  %10.3e  %12.5e',alpha,info.f-f0,gd,(info.f-f0)/alpha);
        end
        alpham = alpha;
        fm     = info.f;
        gm     = gd;
        if alphap == inf        % extrapolation
          alpha = esg*alpha;
%         [alpha] = extrapol3 (esg,0,f0,g0,alpham,fm,gm);
          esg = esg*2;
        else                    % interpolation
%         if isempty(fp)
            alpha = 0.5*(alpham+alphap);
%         else
%           [alpha] = interpol3 (isg,alpham,fm,gm,alphap,fp,gp);
%         end
        end
      end
    else
      if options.verbose > 4
        fprintf(options.fout,'\n   %10.4e]  %10.3e  %10.3e  %12.5e',alpha,info.f-f0,gd,(info.f-f0)/alpha);
      end
      alphap = alpha;
      fp     = info.f;
      gp     = gd;
      % find a new stepsize alpha in (alpham,alphap) by interpolation
      ip = ip + 1;
      if ip > max_ip
        alpha = 0.5*(alpham+alphap);
      else
%       [alpha] = interpol3a (isg,alpham,fm,gm,alphap,fp,gp);
        [alpha] = interpol3 (alpham,alphap,isg,f0,g0,fp,gp);
%       [alpha] = interpol2 (alpham,alphap,isg,f0,g0,fp);
      end
    end

  end   % end of the Wolfe linesearch

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [t] = interpol2 (tm,tp,isg,f0,g0,fp);

%
% [t] = interpol2 (tm,tp,isg,f0,g0,fp);
%
% Finds a new stepsize "t" in [(1-isg)*tm+isg*tp, isg*tm+(1-isg)*tp], by
% a quadratic interpolation, using the value f0 and derivative g0 at 0
% and the value fp at tp.

% preliminaries

  delta = tp-tm;
  tmin  = tm+isg*delta;
  tmax  = tp-isg*delta;

% the quadratic model is t -> a*t^2 + b*t + c

  delta = tp;

  a = (fp-delta*g0-f0)/delta^2;
  b = g0;
  c = f0;

% case when the model is quadratic

  if a > 0              % convex quadratic model
    t = - b/(2*a);
    t = max(tmin,min(tmax,t));
  elseif a < 0          % concave quadratic model
    ptmin = (a*tmin+b)*tmin+c;
    ptmax = (a*tmax+b)*tmax+c;
    if ptmin < ptmax
      t = tmin;
    else
      t = tmax;
    end
  else                  % linear model
    if b < 0
      t = tmax;
    elseif b > 0        % should never occur
      t = tmin;
    else                % should never occur
      t = 0.5*(tm+tp);
    end
  end

  return

return

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 
%% function [t] = interpol3a (isg,tm,fm,gm,tp,fp,gp);
%% 
%% %
%% % [t] = interpol3a (isg,tm,fm,gm,tp,fp,gp);
%% %
%% % Finds a new stepsize "t" in [(1-isg)*tm+isg*tp, isg*tm+(1-isg)*tp], by
%% % a cubic interpolation of the values of f (namely fm and fp) and its
%% % derivatives (gm and gp) at the steps tm and tp.
%% 
%% % preliminaries
%% 
%%   delta = tp-tm;
%%   gamma = (fp-fm-delta*gm)/delta^2;
%%   tmin  = tm+isg*delta;
%%   tmax  = tp-isg*delta;
%% 
%% % the cubic model is t -> a*(t-tm)^3 + b*(t-tm)^2 + c*(t-tm) + d
%% 
%%   a = (gp-gm-2*delta*gamma)/delta^2;
%%   b = -delta*a+gamma;
%%   c = gm;
%%   d = fm;
%% 
%% % case when the model is quadratic
%% 
%%   if a == 0
%%     if b > 0            % convex quadratic model
%%       t = tm - c/(2*b);
%%       t = max(tmin,min(tmax,t));
%% fprintf('\ninterpolation, case 1 is fine\n');
%%     elseif b < 0        % concave quadratic model
%%       ptmin = ((a*(tmin-tm)+b)*(tmin-tm)+c)*(tmin-tm)+d;       % = p(tmin)
%%       ptmax = ((a*(tmax-tm)+b)*(tmax-tm)+c)*(tmax-tm)+d;       % = p(tmax)
%%       if ptmin < ptmax
%%         t = tmin;
%% fprintf('\ninterpolation, case 2\n');
%%       else
%%         t = tmax;
%% fprintf('\ninterpolation, case 3\n');
%%       end
%%     else                % linear model
%%       if c < 0
%%         t = tmax;
%% fprintf('\ninterpolation, case 4\n');
%%       elseif c > 0
%%         t = tmin;
%% fprintf('\ninterpolation, case 5\n');
%%       else
%%         t = 0.5*(tm+tp);
%% fprintf('\ninterpolation, case 6\n');
%%       end
%%     end
%%     ploti (t,tm,fm,gm,tp,fp,gp);
%%     return
%%   end
%% 
%% % case when the model is monotone (the derivative vanishes at most one point)
%% 
%%   D = b^2-3*a*c;
%% 
%%   if D <= 0
%%     if gm < 0           % the polynomial is always decreasing
%%       t = tmax;
%% fprintf('\ninterpolation, case 7\n');
%%     elseif gm > 0       % the polynomial is always increasing
%%       t = tmin;
%% fprintf('\ninterpolation, case 8\n');
%%     else        % here D = b = c = 0
%%       if a < 0          % the polynomial is always decreasing
%%         t = tmax;
%% fprintf('\ninterpolation, case 9\n');
%%       elseif a > 0        % the polynomial is always increasing
%%         t = tmin;
%% fprintf('\ninterpolation, case 10\n');
%%       else              % the polynomial is constant
%%         t = 0.5*(tm+tp);
%% fprintf('\ninterpolation, case 11\n');
%%       end
%%     end
%% %   ploti (t,tm,fm,gm,tp,fp,gp);
%%     return
%%   end
%% 
%% % case when the model is cubic (a ~= 0) and has stationary points (D > 0)
%% 
%%   sqrtD = sqrt(D);
%% 
%%   if a < 0      % the polynomial is 'un', then the local minimum is the first stationary point
%% 
%% %   a
%% %   b
%% %   c
%% %   sqrtD
%% %   tmin
%% %   tmax
%% %   tm-b/(3*a)
%% %   tm-(b+sqrtD)/(3*a)
%% 
%%     ts = tm-(b-sqrtD)/(3*a);
%%     ptmax = ((a*(tmax-tm)+b)*(tmax-tm)+c)*(tmax-tm)+d;         % = p(tmax)
%%     if tmin <= ts                               % then choose the best of p(ts) and p(tmax)
%%       pts = ((a*(ts-tm)+b)*(ts-tm)+c)*(ts-tm)+d;               % = p(ts)
%%       if ptmax <= pts
%%         t = tmax;
%% fprintf('\ninterpolation, case 12\n');
%%       else
%%         t = min(tmax,ts);
%% fprintf('\ninterpolation, case 13\n');
%%       end
%%     else                                        % then choose the best of p(tmin) and p(tmax)
%%       ptmin = ((a*(tmin-tm)+b)*(tmin-tm)+c)*(tmin-tm)+d;       % = p(tmin)
%%       if ptmax <= ptmin
%%         t = tmax;
%% fprintf('\ninterpolation, case 14\n');
%%       else
%%         t = tmin;
%% fprintf('\ninterpolation, case 15\n');
%%       end
%%     end
%% 
%%   else          % the polynomial is 'nu', then the local minimum is the second stationary point
%% 
%%     ts = tm-(b-sqrtD)/(3*a);
%%     ptmin = ((a*(tmin-tm)+b)*(tmin-tm)+c)*(tmin-tm)+d;         % = p(tmin)
%%     if tmax <= ts                               % then choose the best of p(tmin) and p(tmax)
%%       ptmax = ((a*(tmax-tm)+b)*(tmax-tm)+c)*(tmax-tm)+d;       % = p(tmax)
%%       if ptmax < ptmin
%%         t = tmax;
%% fprintf('\ninterpolation, case 16\n');
%%       else
%%         t = tmin;
%% fprintf('\ninterpolation, case 17\n');
%%       end
%%     else                                        % then choose the best of p(tmin) and p(ts)
%%       pts = ((a*(ts-tm)+b)*(ts-tm)+c)*(ts-tm)+d;               % = p(ts)
%%       if ptmin <= pts
%%         t = tmin;
%% fprintf('\ninterpolation, case 18\n');
%%       else
%%         t = max(tmin,min(tmax,ts));
%% fprintf('\ninterpolation, case 19\n');
%%       end
%%     end
%% 
%%   end
%% 
%%   ploti (t,tm,fm,gm,tp,fp,gp);
%% 
%% return
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [t] = interpol3 (tm,tp,isg,f0,g0,fp,gp);

%
% [t] = interpol3 (tm,tp,isg,f0,g0,fp,gp);
%
% Finds a new stepsize "t" in [(1-isg)*tm+isg*tp, isg*tm+(1-isg)*tp], by
% a cubic interpolation of the values of f (namely f0 and fp) and its
% derivatives (g0 and gp) at the steps 0 and tp.

% preliminaries

  delta = tp-tm;
  tmin  = tm+isg*delta;
  tmax  = tp-isg*delta;

% the cubic model is t -> a*t^3 + b*t^2 + c*t + d

  delta = tp;
  gamma = (fp-f0-delta*g0)/delta^2;

  a = (gp-g0-2*delta*gamma)/delta^2;
  b = -delta*a+gamma;
  c = g0;
  d = f0;

% case when the model is quadratic

  if a == 0
    if b > 0            % convex quadratic model
      t = - c/(2*b);
      t = max(tmin,min(tmax,t));
%fprintf('  interpolation, case 1 is fine');
    elseif b < 0        % concave quadratic model
      ptmin = ((a*tmin+b)*tmin+c)*tmin+d;       % = p(tmin)
      ptmax = ((a*tmax+b)*tmax+c)*tmax+d;       % = p(tmax)
      if ptmin < ptmax
        t = tmin;
%fprintf('  interpolation, case 2');
      else
        t = tmax;
%fprintf('  interpolation, case 3');
      end
    else                % linear model
      if c < 0
        t = tmax;
%fprintf('  interpolation, case 4');
      elseif c > 0
        t = tmin;
%fprintf('  interpolation, case 5');
      else
        t = 0.5*(tm+tp);
%fprintf('  interpolation, case 6');
      end
    end
%ploti (t,f0,g0,tm,tp,fp,gp);
    return
  end

% case when the model is monotone (the derivative vanishes at most one point)

  D = b^2-3*a*c;

  if D <= 0
    if g0 < 0           % the polynomial is always decreasing
      t = tmax;
%fprintf('  interpolation, case 7');
    elseif g0 > 0       % the polynomial is always increasing
      t = tmin;
%fprintf('  interpolation, case 8');
    else        % here D = b = c = 0
      if a < 0          % the polynomial is always decreasing
        t = tmax;
%fprintf('  interpolation, case 9');
      elseif a > 0        % the polynomial is always increasing
        t = tmin;
%fprintf('  interpolation, case 10');
      else              % the polynomial is constant
        t = 0.5*(tm+tp);
%fprintf('  interpolation, case 11');
      end
    end
ploti (t,f0,g0,tm,tp,fp,gp);
    return
  end

% case when the model is cubic (a ~= 0) and has stationary points (D > 0)

  sqrtD = sqrt(D);

  if a < 0      % the polynomial is 'un', then the local minimum is the first stationary point

%   a
%   b
%   c
%   sqrtD
%   tmin
%   tmax

    ts = -(b-sqrtD)/(3*a);
    ptmax = ((a*tmax+b)*tmax+c)*tmax+d;         % = p(tmax)
    if tmin <= ts                               % then choose the best of p(ts) and p(tmax)
      pts = ((a*ts+b)*ts+c)*ts+d;               % = p(ts)
      if ptmax <= pts
        t = tmax;
%fprintf('  interpolation, case 12');
      else
        t = min(tmax,ts);
%fprintf('  interpolation, case 13');
      end
    else                                        % then choose the best of p(tmin) and p(tmax)
      ptmin = ((a*tmin+b)*tmin+c)*tmin+d;       % = p(tmin)
      if ptmax <= ptmin
        t = tmax;
%fprintf('  interpolation, case 14');
      else
        t = tmin;
%fprintf('  interpolation, case 15 is fine');
%tmin
%tmax
%t
      end
    end

  else          % the polynomial is 'nu', then the local minimum is the second stationary point

    ts = -(b-sqrtD)/(3*a);
    ptmin = ((a*tmin+b)*tmin+c)*tmin+d;         % = p(tmin)
    if tmax <= ts                               % then choose the best of p(tmin) and p(tmax)
      ptmax = ((a*tmax+b)*tmax+c)*tmax+d;       % = p(tmax)
      if ptmax < ptmin
        t = tmax;
%fprintf('  interpolation, case 16');
      else
        t = tmin;
%fprintf('  interpolation, case 17');
      end
    else                                        % then choose the best of p(tmin) and p(ts)
      pts = ((a*ts+b)*ts+c)*ts+d;               % = p(ts)
      if ptmin <= pts
        t = tmin;
%fprintf('  interpolation, case 18');
      else
        t = max(tmin,min(tmax,ts));
%fprintf('  interpolation, case 19 is fine');
      end
    end

  end

%ploti (t,f0,g0,tm,tp,fp,gp);

return

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 
%% function [t] = extrapol3 (esg,tm,fm,gm,tp,fp,gp);
%% 
%% %
%% % [t] = extrapol3 (esg,tm,fm,gm,tp,fp,gp);
%% %
%% % Finds a new stepsize "t" in [esg*tp,inf[ (esg is the safeguard), by a
%% % cubic interpolation of the values of f (namely fm and fp) and its
%% % derivatives (gm and gp) at the steps tm and tp.
%% 
%% % preliminary
%% 
%%   delta = tp-tm;
%%   gamma = (fp-fm-delta*gm)/delta^2;
%%   tmin  = tp*esg;
%% 
%% % the cubic model is t -> a*(t-tm)^3 + b*(t-tm)^2 + c*(t-tm) + d
%% 
%%   a = (gp-gm-2*delta*gamma)/delta^2;
%%   b = -delta*a+gamma;
%%   c = gm;
%%   d = fm;
%% 
%% % case when the model is quadratic
%% 
%%   if a == 0
%%     if b > 0            % convex quadratic model
%%       t = tm - c/(2*b);
%%       t = max(tmin,t);
%% %fprintf('\nextrapolation, case 1\n');
%% %pause;
%%     else                % concave quadratic or linear model
%%       t = tmin;
%% %fprintf('\nextrapolation, case 2\n');
%% %pause;
%%     end
%% %   ploti (t,tm,fm,gm,tp,fp,gp);
%%     return
%%   end
%% 
%% % case when the model is monotone
%% 
%%   D = b^2-3*a*c;
%%   if D <= 0
%%     t = tmin;
%% %fprintf('\nextrapolation, case 3\n');
%% %pause;
%% %   ploti (t,tm,fm,gm,tp,fp,gp);
%%     return
%%   end
%% 
%% % case when the model is cubic (a ~= 0) and has stationary points (D > 0)
%% 
%%   sqrtD = sqrt(D);
%%   if a < 0
%% 
%%     % the polynomial is 'un', then the local minimum is the first stationary point
%%     ts = tm-(b-sqrtD)/(3*a);
%%     if tmin <= ts
%%       t = ts;
%% %fprintf('\nextrapolation, case 4\n');
%% %pause;
%%     else
%%       t = tmin;
%% %fprintf('\nextrapolation, case 5\n');
%% %pause;
%%     end
%% 
%%   else
%% 
%%     % the polynomial is 'nu', then the local minimum is the second stationary point
%%     ts = tm-(b-sqrtD)/(3*a);
%%     if tmin <= ts
%%       t = ts;
%% %fprintf('\nextrapolation, case 6\n');
%% %pause;
%%     else
%%       t = tmin;
%% %fprintf('\nextrapolation, case 7\n');
%% %pause;
%%     end
%% 
%%   end
%% 
%% % ploti (t,tm,fm,gm,tp,fp,gp);
%% 
%% return
%% 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 
%% function [] = ploti2 (t,tm,tp,isg,f0,g0,fp)
%% 
%% % preliminaries
%% 
%%   delta = tp-tm;
%%   tmin  = tm+isg*delta;
%%   tmax  = tp-isg*delta;
%% 
%% % the cubic model is t -> a*t^2 + b*t + c
%% 
%%   delta = tp;
%% 
%%   a = (fp-delta*g0-f0)/delta^2;
%%   b = g0;
%%   c = f0;
%% 
%% % plot
%% 
%%   cf = gcf;
%%   figure(2);
%%   clf;
%%   axis auto
%%   hold on
%% 
%%   dt = tp/200;
%%   tt = 0:dt:tp;
%% 
%%   pp = (a*tt+b).*tt+c;
%%   plot (tt,pp,'b');
%% 
%%   plot(t,(a*t+b)*t+c,'.r','MarkerSize',20);
%%   plot(tmin,(a*tmin+b)*tmin+c,'ok','MarkerSize',10);
%%   plot(tmax,(a*tmax+b)*tmax+c,'ok','MarkerSize',10);
%%   pause
%%   figure(cf);
%% 
%% return
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 
%% function [] = ploti (t,f0,g0,tm,tp,fp,gp);
%% 
%% % preliminaries
%% 
%%   delta = tp-tm;
%%   isg = 0.01;
%%   tmin  = tm+isg*delta;
%%   tmax  = tp-isg*delta;
%% 
%% % preliminaries
%% 
%%   delta = tp;
%%   gamma = (fp-f0-delta*g0)/delta^2;
%% 
%% % the cubic model is t -> a*t^3 + b*t^2 + c*t + d
%% 
%%   a = (gp-g0-2*delta*gamma)/delta^2;
%%   b = -delta*a+gamma;
%%   c = g0;
%%   d = f0;
%% 
%% % plot
%% 
%%   cf = gcf;
%%   figure(2);
%%   clf;
%%   axis auto
%%   hold on
%% 
%% % t
%% % tm
%% % fm
%% % gm
%% % tp
%% % fp
%% % gp
%%   tini = min(t,tm);
%%   tfin = max(t,tp);
%%   dt = (tfin-tini)/200;
%%   tt = tini:dt:tfin;
%% 
%%   pp = ((a*tt+b).*tt+c).*tt+d;
%%   plot (tt,pp,'b');
%% 
%% % pp(1)
%% % pp(end)
%% % isg = 0.01;
%% % t1 = tm+isg*delta;
%% % ((a*(t1-tm)+b).*(t1-tm)+c).*(t1-tm)+d
%% % t2 = tp-isg*delta;
%% % ((a*(t2-tm)+b).*(t2-tm)+c).*(t2-tm)+d
%% 
%%   plot(t,((a*t+b)*t+c)*t+d,'.r','MarkerSize',20);
%%   plot(tmin,((a*tmin+b)*tmin+c)*tmin+d,'ok','MarkerSize',10);
%%   plot(tmax,((a*tmax+b)*tmax+c)*tmax+d,'ok','MarkerSize',10);
%%   pause
%%   figure(cf);
%% 
%% return
