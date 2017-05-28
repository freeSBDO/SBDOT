function [info] = sqplab_badsimul (outdic,info,options,values)

%
% [info] = sqplab_badsimul (outdic,info,options,values)
%
% Print a message, modify info, and return

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

% Let's go

  if outdic == 2
    if options.verbose; fprintf(options.fout,'\n\n### sqplab: the simulator wants to stop\n'); end;
    info.flag = values.stop_on_simul;
  elseif outdic > 2
    if options.verbose; fprintf(options.fout,'\n\n### sqplab: error with the simulator (outdic = %0i)\n',outdic); end;
    info.flag = values.fail_on_simul;
  end

  return
