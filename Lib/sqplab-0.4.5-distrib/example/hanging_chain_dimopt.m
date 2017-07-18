function [n,nb,mi,me] = hanging_chain_dimopt ();

% [n,nb,mi,me] = hanging_chain_dimopt ();
%
% This function returns the dimensions of the problem. More specifically
% . n  = number of variables,
% . nb = number of variables with bounds,
% . mi = number of inequality constraints,
% . me = number of equality constraints.

% Read the data file

  [n,nb,mi,me,xy0,a,b,lb,r,s] = hanging_chain_data();

% Check dimensiions

  if mi ~= (length(lb)-1)*length(r)
    fprintf('(hanging_chain_dimopt) >>> corrupted data file ''%s''\n',pdat);
    fprintf('(hanging_chain_dimopt) >>> mi (=%0i) is not equal to (length(lb)-1)*length(r) (=%0i)\n', ...
      mi,(length(lb)-1)*length(r));
    exit;
  end

  if me ~= length(lb)
    fprintf('(hanging_chain_dimopt) >>> corrupted data file ''%s''\n',pdat);
    fprintf('(hanging_chain_dimopt) >>> me (=%0i) is not equal to length(lb) (=%0i)\n',me,length(lb));
    exit;
  end

  return

end
