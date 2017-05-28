function [x,lm,info] = sqplab (simul,x0,lm0,lb,ub,options)

%
% [x,lm,info] = sqplab (simul,x0);
% [x,lm,info] = sqplab (simul,x0,lm0);
% [x,lm,info] = sqplab (simul,x0,lm0,lb);
% [x,lm,info] = sqplab (simul,x0,lm0,lb,ub);
% [x,lm,info] = sqplab (simul,x0,lm0,lb,ub,options);
%
% The function computes the solution to a smooth nonlinear optimization
% problem possibly having bound contraints on the n variables x(1:n),
% nonlinear inequality constraints (ci), nonlinear equality constraints
% (ce), and state constraint (cs) in an optimal control setting. The
% problem is supposed to be written in the form:
%
%   minimize    f(x)
%   subject to  lb(1:n)      <= x     <= ub(1:n)
%               lb(n+1:n+mi) <= ci(x) <= ub(n+1:n+mi)
%               ce(x) = 0
%               cs(x) = 0
%
% The constraints functions are ci: Rn -> Rmi, ce: Rn -> Rme, and cs :
% RRn -> Rms, which means that there are mi (>=0) inequality
% constraints, me (>=0) equality constraints, and ms (>=0) state
% constraints. Lower and upper bounds can be infinite (see the meaning
% of options.inf below). Equality and state constraints look similar
% but are treated differently by the solver. State constraints cs are
% assumed to have a uniformly surjective Jacobian cs'(x), which is used
% to reduce the number of free variables of the optimization problem.
% When ms is nonzero, the simulator is assumed to provide additional
% information that is discussed below.
%
% On entry in 'sqplab'
%   simul: function handle of the user-supplied simulator; if this one
%     is named mysimul, use the handle @mysimul as the first argument
%   x0: n vector giving the initial guess of the solution, the number
%     of variables is assumed to be the length of the given x0
%   lm0 (optional): n+mi+me+ms vector giving the initial guess of the
%     dual solution (Lagrange or KKT multiplier),
%     - lm0(1:n) is associated with the bound constraints on x
%     - lm0(n+1:n+mi) is associated with the inequality constraints
%     - lm0(n+mi+1:n+mi+me) is associated with the equality constraints
%     - lm0(n+mi+me+1:n+mi+me+ms) is associated with the state
%       constraints;
%     the default value is the least-squares multiplier; the dimensions
%     mi, me, and ms are known after the first call to the simulator
%   lb (optional): n+mi vector giving the lower bound on x (first n
%     components) and ci(x), it can have infinite components (default
%     -inf)
%   ub (optional): n+mi vector giving the upper bound on x (first n
%     components) and ci(x), it can have infinite components (default
%     inf)
%   options (optional): structure for tuning the behavior of 'sqplab'
%     (when a string is required, both lower or uppercase letters can
%     be used, multiple white spaces are considered as a single white
%     space)
%     - options.algo_method = local algorithm to use:
%       . 'quasi-Newton' (default): requires a quasi-Newton algorithm;
%         only first order derivatives will be computed; when ms=0 the
%         full Hessian of the Lagrangian is approximated; when ms is
%         nonzero (optimal control problems), the reduced Hessian of
%         the Lagrangian is approximated and at least two
%         linearizations of the state constraints are performed at each
%         iteration
%       . 'cheap quasi-Newton': requires a cheap version of
%         quasi-Newton algorithm for an optimal control problem (ms is
%         nonzero); only first order derivatives will be computed; the
%         reduced Hessian of the Lagrangian is approximated using the
%         change in the reduced gradient along a direction that is not
%         necessary tangent to the state constraint manifold; this
%         strategy requires the use of an update criterion
%       . 'Newton' requires a Newton algorithm; second order
%         derivatives will be computed either in the form of the
%         Hessian of the Lagrangian (when ms=0) or in the form of the
%         reduced Hessian of the Lagrangian (when ms is nonzero,
%         optimal control problem)
%     - options.algo_globalization specifies the type of globalization
%       technique to use:
%       . 'unit stepsize' prevents sqplab from using a globalization
%         technique,
%       . 'linesearch' requires sqplab to force convergence with
%         linesearch (default)
%     - options.dxmin = positive number that specifes the precision to
%       which the primal variables must be determined; if the solver
%       needs to make a step smaller than 'dxmin' in the infinity-norm
%       to progress to optimality, it will stop; a too small value will
%       force the solver to work for nothing at the very end when
%       rounding errors prevent making any progress (default 1.e-20)
%     - options.fout = FID for the printed output file (default 1,
%       i.e., the screen)
%     - options.inf = a lower bound lb(i) <= -options.inf will be
%       considered to be absent and an upper bound ub(i) >= options.inf
%       will be considered to be obsent (default = inf)
%     - options.miter = maximum number of iterations (default = 1000)
%     - options.tol = tolerance on optimality
%       (1) = tolerance on the Lagrangian gradient
%       (2) = tolerance on feasibility
%     - options.verbose = verbosity level for the outputs (default 1)
%        = 0: nothing is printed
%       >= 1: error messages (default)
%       >= 2: initial setting and final status
%       >= 3: one line per iteration
%       >= 4: details on the iterations
%       >= 5: details on the globalization
%       >= 6: some additional information, requiring expensive
%             operations, such as the computation of eigenvalues
%
% On return from 'sqplab'
%   x: n vector giving the computed primal solution
%   lm: n+mi+me vector giving the dual solution (Lagrange or KKT
%     multiplier),
%     - lm(1:n) is associated with the bound constraints on x
%     - lm(n+1:n+mi) is associated with the inequality constraints
%     - lm(n+mi+1:n+mi+me) is associated with the equality constraints
%     - lm(n+mi+me+1:n+mi+me+ms) is associated with the state
%       constraints
%   info.flag: output status
%      0: solution found
%      1: an argument is wrong
%      2: unaccepted problem structure
%      3: error on a simulation
%      4: max iterations
%      5: max simulations
%      6: stop required by the simulator
%      7: stop on dxmin
%      8: infeasible QP
%      9: unbounded QP
%     10: nondescent direction (in linesearch)
%     99: should not have happened, call your guru
%   info.niter: number of realized iterations
%   info.nsimul(i): number of simulations with indic = i
%
% To have information on the problem, 'sqplab' uses a simulator (direct
% communication), whose name is given by the argument 'simul'. If
% 'mysimul' is the name of the simulator, the procedure is called by
% sqplab by one of the following manner
%
%   [outdic] = mysimul (indic,x,lm);                 % indic=1
%   [outdic,f,ci,ce,cs,g,ai,ae] = mysimul (indic,x); % indic=2:4
%   [outdic,hl] = mysimul (indic,x,lm);              % indic=5:6
%   [outdic,hlv] = mysimul (indic,x,lm,v);           % indic=7
%   [outdic,mv] = mysimul (indic,x,v);               % indic=11:16
%
% where the inpout and output arguments of 'mysimul' have the following
% meaning:
%   indic is used by 'sqplab' to drive the behavior of the simulator
%      1: the simulator will do whatever (the simulator is called with
%         indic = 1 at each iteration, so that these calls can be used
%         to count the iterations within the simulator)
%      2: the simulator will compute f(x), ci(x), ce(x), and cs(x)
%      3: the simulator will compute g(x), ai(x), and ae(x), and
%         prepare for subsequent evaluations of as(x)*v, asm(x)*v,
%         zsm(x)*v, etc
%      4: the simulator will compute f(x), ci(x), ce(x), cs(x), g(x),
%         ai(x), and ae(x), and prepare for subsequent evaluations of
%         as(x)*v, asm(x)*v, zsm(x)*v, etc
%      5: the simulator will compute hl(x,lm)
%     11: the simulator will compute as(x)*v, where as(x) is the
%         Jacobian of the state constraint cs at x and v is an n-vector
%     12: the simulator will compute as(x)'*v, where as(x) is the
%         Jacobian of the state constraint cs at x and v is an n-vector
%     13: the simulator will compute asm(x)*v, where asm(x) is a right
%         inverse of the Jacobian of the state constraint cs at x and v
%         is an ms-vector
%     14: the simulator will compute asm(x)'*v, where asm(x) is a right
%         inverse of the Jacobian of the state constraint cs at x and v
%         is an n-vector
%     15: the simulator will compute zsm(x)*v, where zsm(x) is a matrix
%         whose columns form a basis of the null space of as(x) and v
%         is an (n-ms)-vector
%     16: the simulator will compute zsm(x)'*v, where zsm(x) is a
%         matrix whose columns form a basis of the null space of as(x)
%         and v is an n-vector
%   x: n vector of variables at which the functions have to be evaluated
%   lm: KKT (or Lagrange) multiplier associated with the constraints,
%     at which the Hessian of the Lagrangian have to be computed,
%     - lm(1:n) is associated with the bound constraints on x
%     - lm(n+1:n+mi) is associated with the inequality constraints
%     - lm(n+mi+1:n+mi+me) is associated with the equality constraints
%     - lm(n+mi+me+1:n+mi+me+ms) is associated with the state
%       constraints
%   v: a vector that is aimed to multiply one of the matrices as(x),
%     asm(x), asm(x)', zsm(x), and zsm(x)'; its dimension depends on
%     the number of column of the matrix, hence on the value of indic
%     (see above)
%   outdic is supposed to describe the result of the simulation
%      0: the required computation has been done
%      1: x is out of an implicit domain
%      2: the simulator wants to stop
%      3: incorrect input parameters
%   f: cost-function value at x
%   ci: mi-vector giving the inequality constraint value at x
%   ce: me-vector giving the equality constraint value at x
%   cs: ms-vector giving the state constraint value at x
%   g: n vector giving the gradient of f at x
%   ai: matrix giving the Jacobian of the inequality constraints at x
%   ae: matrix giving the Jacobian of the equality constraints at x
%   hl: n x n matrix giving the Hessian of the Lagrangian at (x,lm)
%   mv: is one of the product as(x)*v, asm(x)*v, or zsm(x)*v, depending
%     on the value of indic

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

% Set absent input arguments to empty

  if nargin < 2
    fprintf('\n### sqplab: the first 2 arguments are required\n\n');
    info.flag = 1;
    return
  end
  if nargin < 3; lm0 = []; else lm0 = lm0(:); end
  if nargin < 4; lb  = []; else lb = lb(:); end
  if nargin < 5; ub  = []; else ub = ub(:); end
  if nargin < 6;
    options.fout    = 1;
    options.verbose = 1;
  end

% Prelimnaries:
% - set default output arguments
% - set options (default values if absent, numeric values for lexical options)
% - check the given options
% - get the possible 'values' of options
% - compute function values (in info) and deduce dimensions
% - compute an initial multiplier (if not given)
% - initial printings

  [n,nb,mi,me,ms,x,lm,lb,ub,info,options,values] = sqplab_prelim (simul,x0,lm0,lb,ub,options);
  if info.flag; return; end

% Choose an optimization loop

  if options.algo_globalization == values.trust_regions % trust regions

    [x,lm,info] = sqplab_tr (simul,n,nb,mi,me,x,lm,lb,ub,info,options,values);

  else                                                  % unit stepsize or linesearch

    switch options.algo_method
      case values.newton;
        [x,lm,info] = sqplab_loop (simul,n,nb,mi,me,ms,x,lm,lb,ub,info,options,values);
      case values.quasi_newton
        if ms
          % an optimal control problem with quasi-Newton Hessian approximations is treated by a reduced quasi-Newton algorithm
          sqplab_rqn (simul,n,ms,x,lm,lb,ub,info,options,values);
        else
          [x,lm,info] = sqplab_loop (simul,n,nb,mi,me,ms,x,lm,lb,ub,info,options,values);
        end
      case values.cheap_quasi_newton
        % an optimal control problem with quasi-Newton Hessian approximations is treated by a reduced quasi-Newton algorithm
        sqplab_rqn (simul,n,ms,x,lm,lb,ub,info,options,values);
    end

  end

% Conclude

  sqplab_finish (nb,mi,me,ms,info,options,values)

return
