function [x,lx,ux,dxmin,li,ui,dcimin,infb,tolopt,simcap,info] = hanging_chain_initopt ();

% [x,lx,ux,dxmin,li,ui,dcimin,infb,tolopt,simcap,info] = hanging_chain_initopt ();
%
% This function returns the dimensions of the problem. More specifically
% . n  = number of variables,
% . nb = number of variables with bounds,
% . mi = number of inequality constraints,
% . me = number of equality constraints.

% Global variables

  global HC_fout HC_nj HC_nf HC_a HC_b HC_lb HC_r HC_s HC_axis simul_not_initialized

% Set output variables

  x      = [];
  lx     = [];
  ux     = [];
  dxmin  = [];
  li     = [];
  ui     = [];
  dcimin = [];
  infb   = [];
  tolopt = [];
  simcap = [];
  info   = [];

% fid of the output file

  HC_fout = 1;
  simul_not_initialized = 1;

% Get the data file name

  pdat = 'hanging_chain_data';
  if isempty(pdat)
    fprintf ('(hanging_chain_initopt) >>> no environment variable MODULOPTMATLAB_PDAT\n\n');
    exit;
  end

% Get the dimensions and the initial x from the data function

  [n,nb,mi,me,x,HC_a,HC_b,HC_lb,HC_r,HC_s,HC_axis] = hanging_chain_data();

% number of joints

  HC_nj = round(n/2);
  if HC_nj*2 ~= n,
    fprintf(HC_fout,'\n(hanging_chain_initopt) >>> in data file ''%s'', the number of variables (=%i) must be even\n\n',pdat,n);
    info = -1;
    return
  end
  if HC_nj ~= length(HC_lb)-1,
    fprintf(HC_fout,'\n(hanging_chain_initopt) >>> in data file ''%s'', incompatible numbers of variables (=%i) and bars (=%0i)\n\n', ...
            pdat,n,length(HC_lb));
    info = -1;
    return
  end

% number of floors

  HC_r = HC_r(:);
  HC_s = HC_s(:);
  HC_nf = length(HC_r);
  if length(HC_s) ~= HC_nf,
    fprintf(HC_fout,'\n(hanging_chain_initopt) >>> in data file ''%s'', vectors ''r'' and ''s'' do not have the same length\n\n',pdat);
    info = -1;
    return
  end

% Settings for x

  lx = -inf*ones(n,1);
  ux =  inf*ones(n,1);
  dxmin = sqrt(eps);
  infb = inf;

% Inequality constraints

  if mi
    li = -inf*ones(mi,1);
    ui = zeros(mi,1);
    dcimin = sqrt(eps);
  else
    li = [];
    ui = [];
    dcimin = [];
  end

% Check equality constraints

  if me ~= length(HC_lb),
    fprintf(HC_fout, ...
      '\n(hanging_chain_initopt) >>> in data file ''%s'', incompatible numbers of equality constraints (=%i) and bars (=%0i)\n\n', ...
      pdat,me,length(HC_lb));
    info = -1;
    return
  end

% Tolerances on optimality in sup-norm

  tolopt(1) = 1.e-6;    % on the gradient of the Lagrangian
  tolopt(2) = 1.e-6;    % on feasibility
  tolopt(3) = 1.e-6;    % on multiplier sign

% Simulator capabilities

  simcap(1) = 3;
  simcap(2) = 2;
  simcap(3) = 3;
  simcap(4) = 3;

% Fine termination

  info = 0;

  return

end
