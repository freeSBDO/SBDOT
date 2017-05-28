function [] = hanging_chain_postopt (xy,lm,f,ci,ce,cs,g,ai,ae,hl)

%
% [] = hanging_chain_postopt (xy,lm,f,ci,ce,cs,g,ai,ae,hl)
%
% On entry:
%   xy: optimized variables (the coordinates of the free joints, first the x-coordinates, next the y-coordinates)
%   lm: optimal KKT (or Lagrange) multipliers associated with the constraints
%     lm(1:n) is associated with bound constraints on xy (inexistent here)
%     lm(n+1:n+mi) is associated with the inequality constraints (here the floor constraints)
%     lm(n+mi+1:n+mi+me) is associated with the equality constraints (here the bar length constraints)
%     lm(n+mi+me+1:n+mi+me+ms) is associated with the state constraints
%   f: cost-function value (here the potential energy of the chain)
%   ci: inequality constraint value (here the floor contraint values)
%   ce: equality constraint value (here the gap between the bar lengths and there required values)
%   ce: state constraint value
%   g: gradient of f
%   ai: Jacobian of the inequality constraints (sparse)
%   ae: Jacobian of the equality constraints (sparse)
%   hl: Hessian of the Lagrangian

% Global variables

  global HC_fout HC_nj HC_nf
  global foutxy

% Set n, nb, mi, and me

  pdat = 'hanging_chain_data';
  [n,nb,mi,me] = feval(pdat);           % run the data file script

% Print the resulting hanging chain

  x=xy(1:HC_nj);
  y=xy(HC_nj+1:n);
  fprintf(HC_fout,'\n\nJoint positions');
  if mi
    fprintf(HC_fout,' (and floor multipliers)');
  end
  fprintf(HC_fout,':\n   #j      x         y   ');
  if mi
    for j=1:HC_nf
      fprintf(HC_fout,'  mult (floor %0i)',j);
    end
    lmI = lm(n+1:n+mi);
  end
  for i=1:HC_nj
    fprintf(HC_fout,'\n  %3i  %8.5f  %8.5f',i,x(i),y(i));
    for j=1:HC_nf
      fprintf(HC_fout,'  %14.7e',lmI((j-1)*HC_nj+i));
    end
  end
  fprintf(HC_fout,'\n');

% Plot of the found hanging chain

  hanging_chain_plot (xy,'final');
% print -depsc2 hanging_chain.eps;       % print figure

% Close file

  fclose(foutxy);

end
