function [outdic,out2,out3,out4,out5,out6,out7,out8] = simulopt (indic,xy,lm)

%
% [outdic] = simulopt (indic,xy);
% [outdic,f,ci,ce,cs,g,ai,ae] = simulopt (indic,xy)
% [outdic,hl] = simulopt (indic,xy,lm)
%
% Simulator for the "Hanging Chain Project" (type "help ch" to learn more on
% this project). The function can be called by one of the statements above.
% This is compatible with the optimization solver 'sqplab'.
%
% On entry:
%   indic is used to drive the behavior of the simulator; indeed, this one is
%     not driven by the number of its input and/or output arguments but by the
%     value found in 'indic'; possible values are:
%      1: the simulator can do whatever (here it plots the chain)
%      2: compute f, ci, and ce
%      3: compute g, ai, and ae
%      4: compute f, ci, ce, g, ai, and ae
%      5: compute hl
%   xy: variables to optimize (the coordinates of the free joints, first the
%     x-coordinates, next the y-coordinates)
%   lm: KKT (or Lagrange) multiplier associated with the constraints
%     lm(1:n) is associated with bound constraints on xy (inexistent here)
%     lm(n+1:n+mi) is associated with the inequality constraints (here the
%       floor constraints)
%     lm(n+mi+1:n+mi+me) is associated with the equality constraints (here the
%       bar length constraints)
%     lm(n+mi+me+1:n+mi+me+ms) is associated with the state constraints
%
% On return
%   outdic describes the result of the simulation
%     0: the required computation has been done
%    -1: xy is out of an implicit domain
%    -2: stop the optimization please (something wrong)
%   f: cost-function value (here the potential energy of the chain)
%   ci: inequality constraint value (here the floor contraint values)
%   ce: equality constraint value (here the gap between the bar lengths and
%     there required values)
%   g: gradient of f
%   ai: Jacobian of the inequality constraints (sparse)
%   ae: Jacobian of the equality constraints (sparse)
%   hl: Hessian of the Lagrangian

% Global and persistent variables

  global HC_fout HC_nj HC_nf HC_a HC_b HC_lb HC_r HC_s HC_axis simul_not_initialized
  global foutxy

  persistent n mi me nbars iter
  persistent fig_simul domain

% On the output arguments

  outdic = [];
  out2   = [];
  out3   = [];
  out4   = [];
  out5   = [];
  out6   = [];
  out7   = [];
  out8   = [];

% Set global and persistent variables (only once)

  if simul_not_initialized

    foutxy = fopen('hanging_chain.out','w');    % fid of the file with the xy coordinates of the hanging chain
    pdat = 'hanging_chain_data';                % name of the data file script
    [n,nb,mi,me,xy0] = feval(pdat);             % run the data file script

    % number of bars
    nbars = HC_nj+1;
    if nbars < 1,
      fprintf(HC_fout,'\n(simulopt) >>> in data file ''%s'', the number of bars (=%i) must be >= 1\n\n',pdat,nbars);
      outdic = -2;
      return
    end

    % definition of an implicit constraint for xy
    % 0: no implicit constraint,
    % 1: 0<x(i)<1,
    % 2: 0<x(i)<x(i+1)<1,
    % 3: convex chain
    domain = 0;

    % figure material
    fig_simul = 1;
    figure(fig_simul);
    clf(fig_simul);
    axis equal;
    axis (HC_axis);
    axis off;
    hold on;
    hanging_chain_plot (xy0,'first');

    % iteration counter
    iter = 0;

    % initialisation has been done
    simul_not_initialized = 0;

  end

% Call the appropriate function, depending on the value of indic

  % free call: a plot will be done

  if indic == 1

    if nargin < 1
      fprintf(HC_fout,'\n(simulopt) >>> not enough input arguments (%0i < 1) with indic = %0i\n\n',nargin,indic);
      outdic = -2;
      return
    end

    if iter
      hanging_chain_plot (xy,'intermediate');
    end

    iter = iter+1;

    fprintf(foutxy,'\nxx(:,%0i) = [',iter);
    fprintf(foutxy,'0');
    for i=1:HC_nj, fprintf(foutxy,'  %12.5e',xy(i)); end
    fprintf(foutxy,' %12.5e',HC_a);
    fprintf(foutxy,'];');

    fprintf(foutxy,'\nyy(:,%0i) = [',iter);
    fprintf(foutxy,'0');
    for i=1:HC_nj, fprintf(foutxy,'  %12.5e',xy(HC_nj+i)); end
    fprintf(foutxy,'  %12.5e',HC_b);
    fprintf(foutxy,'];\n');

  % functions and their derivatives: f, ci, ce, g, ai, and ae

  elseif (2 <= indic) & (indic <= 4)

    if nargin < 2
      fprintf(HC_fout,'\n(simulopt) >>> not enough input arguments (%0i < 2) with indic = %0i\n\n',nargin,indic);
      outdic = -2;
      return
    end
    [outdic,out2,out3,out4,out6,out7,out8] = chs_fg (indic,xy);

  % requiring hl

  elseif indic == 5

    if nargin < 3
      fprintf(HC_fout,'\n(simulopt) >>> not enough input arguments (%0i < 3) with indic = %0i\n\n',nargin,indic);
      outdic = -2;
      return
    end
    if nargout < 2
      fprintf(HC_fout,'\n(simulopt) >>> not enough output arguments (%0i < 2) with indic = %0i\n\n',nargout,indic);
      outdic = -2;
      return
    end
    [outdic,out2] = chs_hl (xy,lm);

  else

    fprintf(HC_fout,'\n(simulopt) >>> unexpected value of indic (=%i)\n\n',indic);
    outdic = -2;
    return

  end

% call the appropriate function, depending on the value of indic

  return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nested functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-----------------------------------------------------------------------
% Computation of f, ci, ce, g, ai, and ae
%-----------------------------------------------------------------------

function [outdic,f,ci,ce,g,ai,ae] = chs_fg (indic,xy)

% Initialization

  outdic = [];
  f      = [];
  ci     = [];
  ce     = [];
  g      = [];
  ai     = [];
  ae     = [];

% Split xy

  x  = xy(1:HC_nj);
  xx = [x;HC_a];
  xm = [0;x];
  y  = xy(HC_nj+1:n);
  yy = [y;HC_b];
  ym = [0;y];

  lbn = HC_lb(1:HC_nj);
  lbp = HC_lb(2:nbars);

% check whether x is in the implicit domain

  if domain >= 1,				% tester si 0 < x(i) < HC_a

    for i=1:HC_nj
      if x(i) <= 0 | x(i) >= HC_a
        outdic = -1;
        return
      end
    end

    if domain >= 2				% ... et si x(i) < x(i+1)
      for i=1:HC_nj-1
        if x(i+1) <= x(i)
          outdic = -1;
          return
        end
      end

      eps2=sqrt(eps);
      if domain >= 3			% ... et si la chaine est convexe
        if y(2) < x(2)/x(1)*y(1)-eps2
          outdic = -1;
          return
        end
        for i=2:HC_nj-1
          if y(i+1) < y(i-1)+(x(i+1)-x(i-1))/(x(i)-x(i-1))*(y(i)-y(i-1))-eps2
            outdic = -1;
            return
          end
        end
        if HC_b < y(HC_nj-1)+(HC_a-x(HC_nj-1))/(x(HC_nj)-x(HC_nj-1))*(y(HC_nj)-y(HC_nj-1))-eps2
          outdic = -1;
          return
        end
      end

    end

  end

% compute f, ce, ci, g, ae, and ai

  if (indic == 2) | (indic == 4)      % compute the functions f, ce, and ci

    % f

    f = sum(HC_lb.*(yy+ym))/2;

    % ce

    l = sqrt((xx-xm).^2+(yy-ym).^2);
    ce = l.^2-HC_lb.^2;

    % ci

    if HC_nf
      ci = kron(HC_r,ones(HC_nj,1))+kron(HC_s,x)-kron(ones(HC_nf,1),y);
    end

  end


  if (indic == 3) | (indic == 4)      % compute the derivatives g, ae, and ai

    % g

    g = [zeros(HC_nj,1); (lbn+lbp)/2];

    % ae

    i = [[1:HC_nj]';[2:nbars]';[1:HC_nj]';[2:nbars]'];
    j = [[1:HC_nj]';[1:HC_nj]';[nbars:n]';[nbars:n]'];
    v = [2*(x-xm(1:HC_nj));2*(x-xx(2:nbars));
         2*(y-ym(1:HC_nj));2*(y-yy(2:nbars))];
    ae = sparse(i,j,v,me,n);

    % ai

    if HC_nf
      e = ones(HC_nj,1);
      ai = [kron(HC_s,speye(HC_nj)),kron(-ones(HC_nf,1),speye(HC_nj))];
    end

  end

  outdic = 0;

  return

end

%-----------------------------------------------------------------------
% Computation of hl
%-----------------------------------------------------------------------

function [outdic,hl] = chs_hl (xy,lm)

% Initialization

  outdic = [];
  hl     = [];

% Split xy

  x  = xy(1:HC_nj);
  y  = xy(HC_nj+1:n);

% check x

  if domain >= 1,				% tester si 0 < x(i) < HC_a

    for i=1:HC_nj
      if x(i) <= 0 | x(i) >= HC_a
        outdic = -1;
        return
      end
    end

    if domain >= 2				% ... et si x(i) < x(i+1)
      for i=1:HC_nj-1
        if x(i+1) <= x(i)
          outdic = -1;
          return
        end
      end

      eps2=sqrt(eps);
      if domain >= 3    			% ... et si la chaine est convexe
        if y(2) < x(2)/x(1)*y(1)-eps2
          outdic = -1;
          return
        end
        for i=2:HC_nj-1
          if y(i+1) < y(i-1)+(x(i+1)-x(i-1))/(x(i)-x(i-1))*(y(i)-y(i-1))-eps2
            outdic = -1;
            return
          end
        end
        if HC_b < y(HC_nj-1)+(HC_a-x(HC_nj-1))/(x(HC_nj)-x(HC_nj-1))*(y(HC_nj)-y(HC_nj-1))-eps2
          outdic = -1;
          return
        end
      end

    end

  end

% compute hl

  i = [1:HC_nj-1]';
  j = [2:HC_nj]';
  v = -2*lm(n+2:n+HC_nj);
  hl = sparse(i,j,v,HC_nj,HC_nj);
  hl = hl' + 2*sparse(diag(lm(n+1:n+HC_nj)+lm(n+2:n+nbars))) + hl;
  hl = [   hl     zeros(HC_nj);
        zeros(HC_nj)    hl    ];

  outdic = 0;

  return

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End of nested functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
