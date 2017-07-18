function [info,options] = sqplab_checkoptions (nb,mi,me,ms,info,options,values);

%
% [info] = sqplab_checkoptions (nb,mi,me,ms,info,options,values);
%
% Check the structure 'options' to see whether the required options are
% compatible with the solver capabilities.

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

  info.flag = values.success;

% Restrictions when there are state constraints

  if ms
    if nb+mi+me
      if options.verbose;
        fprintf(options.fout,'\n\n### sqplab_checkoptions: other constraints are not compatible');
        fprintf(options.fout,'\n### with state constraints in this version of SQPLAB\n');
      end
      info.flag = values.fail_on_problem;
      return
    end
%   if options.algo_method == values.newton;
%     if options.verbose;
%       fprintf(options.fout,'\n\n### sqplab_checkoptions: using Newton''s method with state constraints is not');
%       fprintf(options.fout,'\n    recommended; using the ''simplified Newton'' method should be better\n');
%     end
%   end
%   if options.algo_method == values.quasi_newton;
%     if options.verbose;
%       fprintf(options.fout,'\n\n### sqplab_checkoptions: using a quasi-Newton method with state constraints is');
%       fprintf(options.fout,'\n    not recommended; using the ''simplified quasi-Newton'' method should be better\n');
%     end
%   end

% Restrictions when there is no state constraint

  else
    if options.algo_method == values.cheap_quasi_newton
      if options.verbose;
        fprintf(options.fout,'\n\n### sqplab_checkoptions: the cheap quasi-Newton method is not a valid');
        fprintf(options.fout,'\n### approach when there is no state constraint\n');
      end
      info.flag = values.fail_on_problem;
      return
    end
  end

% How is descent ensured

  switch options.algo_globalization

    case values.unit_stepsize           % unit stepsize

      if options.algo_method ~= values.newton;  % quasi-Newton method with unit stepsize !
        if ~isfield(options,'algo_descent')
          if options.verbose
            fprintf(options.fout,'\n\n### sqplab_checkoptions: positive definiteness of the matrices is ensured');
            fprintf(options.fout,'\n### by Powell corrections\n');
          end
          options.algo_descent = values.powell;
        elseif options.algo_descent == values.wolfe
          if options.verbose
            fprintf(options.fout,'\n\n### sqplab_checkoptions: positive definiteness of the matrices cannot be ensured');
            fprintf(options.fout,'\n### by the Wolfe linesearch when unit stepsize is required; Powell corrections');
            fprintf(options.fout,'\n### will be used instead\n');
          end
          options.algo_descent = values.powell;
        end
      end

    case values.linesearch              % linesearch

      if options.algo_method == values.newton;    % Newton method
        if isfield(options,'algo_descent')
          if options.verbose
            fprintf(options.fout,'\n\n### sqplab_checkoptions: descent cannot be ensured for Newton''s method');
            fprintf(options.fout,'\n### by using Powell corrections or Wolfe linesearch\n');
          end
          info.flag = values.fail_on_argument;
          return
        else
          if options.verbose
            fprintf(options.fout,'\n\n### sqplab_checkoptions: Armijo''s linesearch can fail with Newton''s method,');
            fprintf(options.fout,'\n###                      use unit step-size instead\n');
          end
        end
      else                                        % quasi-Newton method
        if ~isfield(options,'algo_descent')
          if options.verbose
            fprintf(options.fout,'\n\n### sqplab_checkoptions: descent ensured by Powell corrections\n');
            if nb+mi+me+ms == 0;
              fprintf(options.fout,'### setting "options.algo_descent = ''Wolfe''" should be better\n');
            end
          end
          options.algo_descent = values.powell;
        elseif (options.algo_descent == values.wolfe) & (nb+mi+me+ms ~= 0)
          if options.verbose
            fprintf(options.fout,'\n\n### sqplab_checkoptions: positive definiteness of the matrices cannot be ensured');
            fprintf(options.fout,'\n### by the Wolfe linesearch when constraints are present; Powell corrections');
            fprintf(options.fout,'\n### will be used instead\n');
          end
          options.algo_descent = values.powell;
        end
      end

    case values.trust_regions           % trust regions

      if nb+mi+ms | ~me
        if options.verbose;
          fprintf(options.fout,'\n\n### sqplab_checkoptions: globalization by trust regions only works for');
          fprintf(options.fout,'\n### equality constrained problems; use linesearch instead\n');
        end
        info.flag = values.fail_on_argument;
      end

  end

% Return

return
