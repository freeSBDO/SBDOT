function [info,options,values] = sqplab_options (info,options)

%%
% [info,options,values] = sqplab_options (info,options)
%
% Set the options of the optimization solver 'sqplab'

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

% Define SQPLAB constant values

  values.success                =   0; % solution found
  values.fail_on_argument       =   1; % an argument is wrong
  values.fail_on_problem        =   2; % unaccepted problem structure
  values.fail_on_simul          =   3; % error on a simulation
  values.stop_on_simul          =   4; % stop required by the simulator
  values.stop_on_max_iter       =   5; % max iterations
  values.stop_on_max_simul      =   6; % max simulations
  values.stop_on_dxmin          =   7; % stop on dxmin
  values.fail_on_non_decrease   =   8; % the merit function no longer decrease
  values.fail_on_ascent_dir     =   9; % nondescent direction in linesearch
  values.fail_on_max_ls_iter    =  10; % too many stepsize trials in linesearch
  values.fail_on_ill_cond       =  11; % ill-conditioning

  values.fail_on_null_step      =  20; % null step d is solution of 'values.max_null_steps' QPs
  values.fail_on_infeasible_QP  =  21; % infeasible QP
  values.fail_on_unbounded_QP   =  22; % unbounded QP

  values.fail_strange           =  99; % should not have happened, call a guru

  values.nsimultype             =  16; % nb of simulation types
  values.max_null_steps         =   1; % maximum nbr of null QP steps

  values.newton                 = 100;
  values.quasi_newton           = 101;
  values.cheap_quasi_newton     = 102;

  values.unit_stepsize          = 110;
  values.linesearch             = 111;
  values.trust_regions          = 112;

  values.powell                 = 120;
  values.wolfe                  = 121;

% Initialization

  info.flag = values.success;

% Force the existence of 'options'

  if isempty(options); options.xxx = 0; end

% Set options

  if isfield(options,'fout')
    if options.fout < 0
      fprintf('\n### sqplab: options.fout = "%0i" is not a valid file identifier (use ''fopen'' to have a valid one)', ...
        options.fout);
      fprintf('\n            options.fout is set to 1\n\n');
      options.fout = 1;
    end
  else
    options.fout = 1;
  end

  if isfield(options,'verbose')
    if (options.verbose < 0) | (options.verbose > 6)
      fprintf(options.fout,'\n### sqplab: options.verbose = "%0i" and should be in [0,6], reset to 1\n\n', options.verbose);
      options.verbose = 1;
    end
  else
    options.verbose = 1;
  end

  if isfield(options,'algo_method')
    switch lower(regexprep(strtrim(options.algo_method),'  *',' '))
      case 'newton'
        options.algo_method = values.newton;
      case {'quasi-newton', 'quasi newton', 'quasinewton'}
        options.algo_method = values.quasi_newton;
      case {'cheap quasi-newton', 'cheap quasi newton', 'cheap quasinewton'}
        options.algo_method = values.cheap_quasi_newton;
      otherwise
        if options.verbose;
          fprintf(options.fout,'\n### sqplab: options.algo_method "%s" not recognized\n\n', options.algo_method);
        end;
        info.flag = values.fail_on_argument;
        return
    end
  else
    options.algo_method = values.quasi_newton;
  end

  if isfield(options,'algo_globalization')
    switch lower(regexprep(strtrim(options.algo_globalization),'  *',' '))
      case {'unit step-size', 'unit stepsize'}
        options.algo_globalization = values.unit_stepsize;
      case {'line-search', 'linesearch'}
        options.algo_globalization = values.linesearch;
      case {'trust regions', 'trust-regions', 'trustregions'}
        options.algo_globalization = values.trust_regions;
      otherwise
        if options.verbose;
          fprintf(options.fout,'\n### sqplab: options.algo_globalization "%s" not recognized\n\n', options.algo_globalization);
        end
        info.flag = values.fail_on_argument;
        return
    end
  else
    options.algo_globalization = values.linesearch;
  end

  if isfield(options,'algo_descent')
    switch lower(regexprep(strtrim(options.algo_descent),'  *',' '))
      case 'powell'
        options.algo_descent = values.powell;
      case 'wolfe'
        options.algo_descent = values.wolfe;
      otherwise
        if options.verbose;
          fprintf(options.fout,'\n### sqplab: options.algo_descent "%s" not recognized\n\n', options.algo_descent);
        end;
        info.flag = values.fail_on_argument;
        return
    end
  end

  if isfield(options,'dxmin')
    if (options.dxmin <= 0)
      if options.verbose; fprintf(options.fout,'\n### sqplab: options.dxmin = %g must be > 0\n\n', options.dxmin); end;
      info.flag = values.fail_on_argument;
      return
    end
  else
    options.dxmin = 1.e-8;
  end

  if isfield(options,'inf')
    if options.inf <= 0
      if options.verbose; fprintf('\n### sqplab: incorrect value of options.inf %g (should be > 0)\n\n',options.inf); end
      info.flag = values.fail_on_argument;
      return
    end
  else
    options.inf = inf;
  end

  if isfield(options,'miter')
    if options.miter <= 0
      if options.verbose; fprintf('\n### sqplab: incorrect value of options.miter %g (should be > 0)\n\n',options.miter); end
      info.flag = values.fail_on_argument;
      return
    end
  else
    options.miter = 1000;
  end

% if isfield(options,'msimul')
%   if options.msimul <= 0
%     if options.verbose; fprintf('\n### sqplab: incorrect value of options.msimul %g (should be > 0)\n\n',options.msimul); end
%     info.flag = values.fail_on_argument;
%     return
%   end
% else
%   options.msimul = 1000;
% end

  if isfield(options,'tol')
    if any(options.tol <= 0)
      if options.verbose; fprintf('\n### sqplab: incorrect value of some options.tol (should be > 0)\n\n'); end
      info.flag = values.fail_on_argument;
      return
    end
  else
    options.tol = [1.e-6;1.e-6;1.e-6];
  end

  if ~isfield(options,'df1')
    options.df1 = 0;
  end

% Return

return
