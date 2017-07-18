function [] = sqplab_finish (nb,mi,me,ms,info,options,values)

% [] = sqplab_finish (nb,mi,me,ms,info,options,values)
%
% Prints output status

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

%===============================================================================

  if options.verbose >= 2
    fprintf(options.fout,'\n%s',values.dline);
    fprintf(options.fout,'\nSQPLAB optimization solver (exit point)');
    fprintf(options.fout,'\n  Status %i: ',info.flag);
    switch info.flag
      case values.success;               fprintf(options.fout,'required tolerances are satisfied');
      case values.fail_on_argument;      fprintf(options.fout,'wrong argument');
      case values.fail_on_problem;       fprintf(options.fout,'unaccepted problem structure');
      case values.fail_on_simul;         fprintf(options.fout,'error when calling the simulator');
      case values.stop_on_simul;         fprintf(options.fout,'the simulator wants to stop');
      case values.stop_on_max_iter;      fprintf(options.fout,'max iteration reached');
      case values.stop_on_max_simul;     fprintf(options.fout,'max simulation reached');
      case values.stop_on_dxmin;         fprintf(options.fout,'too small variation in x (dxmin active)');
      case values.fail_on_non_decrease;  fprintf(options.fout,'the merit function cannot be decreased');
      case values.fail_on_ascent_dir;    fprintf(options.fout,'ascent direction encountered in linesearch');
      case values.fail_on_max_ls_iter;   fprintf(options.fout,'too many stepsize trials in linesearch');
      case values.fail_on_ill_cond;      fprintf(options.fout,'ill conditioning');
      case values.fail_on_null_step;     fprintf(options.fout,'null step d is solution of %0i QPs',values.max_null_steps+1);
      case values.fail_on_infeasible_QP; fprintf(options.fout,'infeasible QP');
      case values.fail_on_unbounded_QP;  fprintf(options.fout,'unbounded QP');
      case values.fail_strange;          fprintf(options.fout,'strange failure, call a guru');
    end
    fprintf(options.fout,'\n  Cost                                    %12.5e',info.f);
    fprintf(options.fout,'\n  Optimality conditions:\n');
    if nb+mi+me+ms
      fprintf(options.fout,'  . gradient of the Lagrangian (inf norm)  %11.5e\n',info.glagn);
      fprintf(options.fout,'  . feasibility                            %11.5e\n',info.feasn);
        if nb+mi; fprintf(options.fout,'  . complementarity                        %11.5e\n',info.compl); end
    else
      fprintf(options.fout,'  Gradient of the cost function (inf norm)  %11.5e\n',info.glagn);
    end
    fprintf(options.fout,'  Counters:\n');
    fprintf(options.fout,'  . nbr of iterations                   %4i\n',info.niter);
    for i=2:values.nsimultype
      if info.nsimul(i); fprintf(options.fout,'  . nbr of simulations(%2i)              %4i\n',i,info.nsimul(i)); end
    end
    fprintf(options.fout,'%s\n',values.sline);
  end

return
