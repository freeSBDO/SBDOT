%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Example of Matlab program using SQPlab as an optimization solver.
%  This one has been adapted from the 'hanging chain' problem of the
%  ModuloptMatlab collection of problems, available in the Libopt
%  environment, located at
%
%      http://www-rocq.inria.fr/estime/modulopt/libopt/libopt.html
%
%  Other data for this problems can be found in this environment.
%
%  The program is executed by typing
%
%      hanging_chain
%
%  in the Matlab window. The simulator adapted to the SQPlab solver is
%  'hanging_chain_simul'.
%
%  SQPlab can solve a minimization problem of the form
%
%      minimize     f(x)
%      subject to   lx <=   x   <= ux
%                   li <= ci(x) <= ui
%                   ce(x) == 0,
%
%  where f: Rn -> R (hence x is the vector of n variables to optimize),
%  lx and ux are lower and upper bounds on x, ci: Rn -> Rmi, li and ui
%  are lower and upper bounds on ci(x), and ce: Rn -> Rme.
%
%  Author: J.Ch. Gilbert, INRIA, December 2008
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Format

  format compact
  format long

%---------------------------------------
% Add the SQPlab directory to the Matlab path
%---------------------------------------

  addpath '../src'

%---------------------------------------
% Get the dimensions
%---------------------------------------

  [n,nb,mi,me] = hanging_chain_dimopt ();
  if isempty(n) || n <= 0
    fprintf ('(%s) >>> hanging_chain_dimopt does not return a correct number of variables (n = %0i)\n',mfilename,n);
    exit;
  end
  if isempty(nb)
    nb = 0;
  elseif nb < 0
    fprintf ('(%s) >>> hanging_chain_dimopt returns a negative number of bounds on the variables (nb = %0i)\n',mfilename,nb);
    exit;
  end
  if isempty(mi)
    mi = 0;
  elseif mi < 0
    fprintf ('(%s) >>> hanging_chain_dimopt returns a negative number of inequality constraints (mi = %0i)\n',mfilename,mi);
    exit;
  end
  if isempty(me)
    me = 0;
  elseif me < 0
    fprintf ('(%s) >>> hanging_chain_dimopt returns a negative number of equality constraints (me = %0i)\n',mfilename,me);
    exit;
  end

%---------------------------------------
% Get the data and initialize the problem
%---------------------------------------

  [x,lx,ux,dxmin,li,ui,dcimin,infb,tolopt,simcap,info] = hanging_chain_initopt ();
  if info < 0
    fprintf ('(%s) >>> error while reading the data with ''hanging_chain_initopt'': info = %0i\n',mfilename,info)
    exit;
  end

  % check the simulator capabilities

  if simcap(1) < 2
    fprintf ('(%s) >>> cost-function gradient not available for this problem: ',mfilename);
    fprintf ('simcap(1) = %0i\n', simcap(1));
    exit;
  end
  if (mi > 0) && (simcap(2) < 1)
    fprintf ('(%s) >>> Jacobian of the inequality constraints not available for this problem: ',mfilename);
    fprintf ('simcap(2) = %0i\n', simcap(2));
    exit;
  end
  if (me > 0) && (simcap(3) < 1)
    fprintf ('(%s) >>> Jacobian of the equality constraints not available for this problem: ',mfilename);
    fprintf ('simcap(3) = %0i\n', simcap(3));
    exit;
  end

  % discard problems having fixed variables or equal bounds, define lb and ub

  nf = sum(lx==ux);
  if nf > 0
    if nf == 1
      fprintf ('\n(%s) there is 1 fixed variable ==> STOP\n\n',mfilename);
    else
      fprintf ('\n(%s) there are %0i fixed variables ==> STOP\n\n',mfilename,nf);
    end
    exit;
  end
  nb0 = sum((lx > -infb) | (ux < infb));
  if nb ~= nb0
    fprintf ('(%s) >>> ''hanging_chain_dimopt'' declares %0i bounds on the variables,\n', mfilename, nb);
    fprintf ('(%s) >>> while ''lx'', ''ux'', and ''infb'' lead to %0i bounds.\n', mfilename, nb0);
    nb = nb0;
  end
  lb = lx;
  ub = ux;

  if mi > 0
    nf = sum(li==ui);
    if nf > 0
      if nf == 1
        fprintf ('\n(%s) there is 1 equal lower and upper bound ==> STOP\n\n',mfilename);
      else
        fprintf ('\n(%s) there are %0i equal lower and upper bounds ==> STOP\n\n',mfilename,nf);
      end
      exit;
    end
    lb(n+1:n+mi) = li;
    ub(n+1:n+mi) = ui;
  end

%---------------------------------------
% Call SQPlab
%---------------------------------------

  lm = [];

  % default options

  options.algo_method        = 'quasi-Newton';
% options.algo_method        = 'Newton';

  options.algo_globalization = 'line-search';
% options.algo_globalization = 'unit step-size';

  if nb+mi+me == 0; options.algo_descent = 'Wolfe'; end

  options.tol(1)  = tolopt(1);  % tolerance on the gradient of the Lagrangian
  options.tol(2)  = tolopt(2);  % tolerance on the feasibility
  options.tol(3)  = tolopt(3);  % tolerance on the complementarity

  options.dxmin   = dxmin;      % minimum size of a step
  options.inf     = infb;       % infinity value for the Moduloptmatlab collection

  options.miter   = 1000;       % max iterations
  options.msimul  = 1000;       % max simulations

  options.fout    = 1;          % print file identifier
  options.verbose = 3;          % verbosity level

  % let's go

  tic;  % start CPU timer

  [x,lm,info] = sqplab (@hanging_chain_simul,x,lm,lb,ub,options);

  cput = toc;
  fprintf(options.fout,'\nCPU time = %f sec',cput);   % print CPU time

%---------------------------------------
% Recover the results
%---------------------------------------

  hanging_chain_postopt (x,lm,info.f,info.ci,info.ce,info.cs,info.g,info.ai,info.ae,info.hl);

  % print the results

  if nb
    fprintf(options.fout,'\nVARIABLES');
    fprintf(options.fout,'\ni      lower bound                x                upper bound           multiplier');
    for i=1:min(n,40)
      fprintf(options.fout,'\n%0i %21.14e %21.14e %21.14e %21.14e',i,lb(i),x(i),ub(i),lm(i));
    end
    if (n > 40); fprintf(options.fout,'\n.....'); end
  else
    fprintf(options.fout,'\nVARIABLES x');
    fprintf(options.fout,'\n%21.14e %21.14e %21.14e %21.14e %21.14e',x(1:min(n,40)));
    if (n > 40); fprintf(options.fout,'\n.....'); end
  end
  if mi
    fprintf(options.fout,'\n\nINEQUALITY CONSTRAINTS');
    fprintf(options.fout,'\ni      lower bound               ci                upper bound           multiplier');
    for i=1:min(mi,40)
      fprintf(options.fout,'\n%0i %21.14e %21.14e %21.14e %21.14e',i,lb(n+i),info.ci(i),ub(n+i),lm(n+i));
    end
    if (mi > 40); fprintf(options.fout,'\n.....'); end
  end
  if me
    fprintf(options.fout,'\n\nEQUALITY CONSTRAINTS');
    fprintf(options.fout,'\ni          ce                multiplier');
    for i=1:min(me,40)
      fprintf(options.fout,'\n%0i %21.14e %21.14e %21.14e %21.14e',i,info.ce(i),lm(n+mi+i));
    end
    if (me > 40); fprintf(options.fout,'\n.....'); end
  end
  fprintf('\n');

  return
