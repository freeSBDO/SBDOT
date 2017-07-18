function [M,pc,info,values] = sqplab_bfgs (M,y,s,first,info,options,values);

%
% [M,info,values] = sqplab_bfgs (M,y,s,first,info,options,values);
%
% This procedure computes the BFGS update of the matrix M, which is
% supposed to be positive definite approximation of some Hessian. If
% y'*s is not sufficiently positive and options.algo_descent is set to
% values.powell, Powell's correction is applied to y.
%
% On entry:
%   M: matrix to update
%   y: gradient variation
%   s: point variation
%   first: if true, the procedure will initialize the matrix M to a
%       multiple of the identity before the update
%
% On return:
%   M: updated matrix

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

%-----------------------------------------------------------------------

% Parameter

  eta = 0.2;    % constant for Powell corrections
% eta = 0.6;    % constant for Powell corrections

%-----------------------------------------------------------------------

% initalization

  n         = length(s);
  pc        = 1;
  info.flag = values.success;

% prepare the update of M

  if norm(s) == 0
    info.flag = values.fail_strange;
    if options.verbose; fprintf(options.fout,'\n\n### sqplab_bfgs: null step s\n'); end
    return
  end
  ys = y'*s;
  if options.verbose >= 4; fprintf(options.fout,': y''*s/(s''*s) = %9.3e',ys/(s'*s)); end
  Ms = M*s;
  sMs = s'*Ms;
  if sMs <= 0
    info.flag = values.fail_strange;
    if options.verbose
      fprintf(options.fout,'\n\n### sqplab_bfgs: BFGS Hessian approximation is not positive definite:');
      fprintf(options.fout,'\n            s''*M*s = %g <= 0\n',sMs);
    end
    return
  end
  if (options.algo_descent == values.powell) & (ys < eta*sMs)    % Powell's correction
    pc = (1-eta)*sMs/(sMs-ys);
    if options.verbose >= 4; fprintf(options.fout,'\n  Powell''s corrector = %7.1e',pc); end
    y = pc*y+(1-pc)*Ms;
    ys = y'*s;  % update ys, since y has changed
    if options.verbose >= 4, fprintf(options.fout,' (new y''*s/(s''*s) = %7.1e)',ys/(s'*s)); end
    if ys <= 0
      info.flag = values.fail_strange;
      if options.verbose; fprintf(options.fout,'\n\n### sqplab_bfgs: y''*s = %9.3e not positive despite correction:\n',ys)'; end
      return
    end
  elseif ys <= 0
    if options.verbose; fprintf(options.fout,'\n\n### sqplab_bfgs: y''*s = %9.3e is nonpositive\n',ys)'; end
    info.flag = values.fail_strange;
    return
  end

% case when the matrix has to be initialized

  if first
    ol = (y'*y)/ys;
%   ol = ys/(s'*s);
    M = ol*eye(n);
    if options.verbose >= 4, fprintf(options.fout,'\n  OL coefficient = %g',ol); end
    Ms = ol*s;
    sMs = s'*Ms;
%   if options.verbose >= 6
%     values.file_eigM = fopen('sqplab_eigM.m','w');
%     fprintf (values.file_eigM,'  Powell''s corrector    Eigenvalues of the updated matrix M\nn=%0i\n',n);
%   end
  end

% update the matrix M (TODO: update with the formula used in SQPpro, which is more stable)

  M = M-(Ms*Ms')/sMs+(y*y')/ys;       % BFGS formula
  if options.verbose >= 6
    eigM = sort(eig(M));
    fprintf(options.fout,'\n  eig(M): min = %g, max = %g, cond = %g',min(eigM),max(eigM),max(eigM)/min(eigM));
%   fprintf (values.file_eigM,'%22.15e',pc);
%   for i = 1:n
%     fprintf (values.file_eigM,'  %22.15e',eigM(i));
%   end
%   fprintf (values.file_eigM,'\n');
  end

return
