  function [feas,compl,info] = sqplab_optimality (simul,x,lm,lb,ub,info,options,values)

%
% [feas,compl,info] = sqplab_optimality (simul,x,lm,lb,ub,info,options,values)

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

% Dimensions

  n  = length(info.g);
  mi = length(info.ci);
  me = length(info.ce);
  ms = length(info.cs);

% Gradient of the Lagrangian

  info.glag = info.g;
  bounds = (lb > -options.inf) + (ub <  options.inf);

  % contribution of the variable bounds

% fprintf('\n     lb             x            ub           glag           lm\n');
% for i=1:n
%   fprintf('%12.5e  %12.5e  %12.5e  %12.5e  %12.5e\n',lb(i),x(i),ub(i),info.glag(i),lm(i));
% end

  I = find(bounds(1:n));
  info.glag(I) = info.glag(I) + lm(I);

  % contribution of the inequality constraints

  if mi > 0
    I = find(bounds(n+1:n+mi));
    info.glag = info.glag + info.ai(I,:)'*lm(n+I);
  end

  % contribution of the equality constraints

  if me > 0
    info.glag = info.glag + info.ae'*lm(n+mi+1:n+mi+me);
  end

  % contribution of the state constraints

  if ms > 0
    info.nsimul(12) = info.nsimul(12) + 1;
    [outdic,astlm] = simul(12,x,lm(n+mi+me+1:n+mi+me+ms));      % astlm = as' * lm(...)
    if outdic
      if outdic == 2,
        if options.verbose; fprintf(options.fout,'\n### sqplab: the simulator wants to stop\n\n'); end;
        info.flag = values.stop_on_simul;
        return
      elseif outdic > 2
        if options.verbose; fprintf(options.fout,'\n### sqplab: error with the simulator (outdic = %0i)\n\n',outdic); end;
        info.flag = values.fail_on_simul;
        return
      end
    end
    info.glag = info.glag + astlm;
  end

% Feasibility (a vector)

  feas = [max(0,max([x;info.ci]-ub,lb-[x;info.ci])); info.ce; info.cs];

% Complementarity (a vector)

  v = [x;info.ci];
  compl = zeros(n+mi,1);

  % lower bounds on v

  I = find((lb > -options.inf) & (abs(lb-v) > options.dxmin));  % v(I) is inactive at its lower bounds
  if ~isempty(I); compl(I) = max(compl(I),max(0,-lm(I))); end   % lm(I) must be >= 0

  % upper bounds on v

  I = find((ub < options.inf) & (abs(ub-v) > options.dxmin));   % v(I) is inactive at its upper bounds
  if ~isempty(I); compl(I) = max(compl(I),max(0,lm(I))); end    % lm(I) must be <= 0

return
