function [sigma,sigmab] = sqplab_sigma (sigma,sigmab,lmqpn,info,options);

%
% [sigma,sigmab] = sqplab_sigma (sigma,sigmab,lmqpn,info,options);
%
% This procedure initializes and/or updates the penalty parameter used
% in the merit function.
%
% On entry:
%   sigma: previous penalty parameter (if info.niter >= 2)
%   sigmab: constant in the penalty factor inequality
%   lmqpn: dual norm of the QP multiplier
%
% On return:
%   sigma: initialized/updated penalty parameter

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

  if info.niter == 1,
    sigmab=max(sqrt(eps),lmqpn/100);
    sigma=lmqpn+sigmab;
    if options.verbose >= 4; fprintf(options.fout,'\n\nPenalty parameter sigma = %8.2e (sigmab = %8.2e)',sigma,sigmab); end
  else
    sigmat=lmqpn+sigmab;
    if sigma < sigmat,
      sigma=max(1.5*sigma,sigmat);
      if options.verbose >= 4, fprintf(options.fout,'\n\nPenalty parameter sigma increased to %8.2e',sigma); end
    elseif sigma > 1.1*sigmat,
      sigma=(sigma+sigmat)/2;
      if options.verbose >= 4, fprintf(options.fout,'\n\nPenalty parameter sigma decreased to %8.2e',sigma); end
    end
  end

return
