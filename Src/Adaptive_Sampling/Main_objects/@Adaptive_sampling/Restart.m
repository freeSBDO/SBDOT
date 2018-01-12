function [] = Restart( obj, iter_sup, fcall_sup )
%RESTART Restart an optimization sequence
% Syntax :
%   obj.Restart()
%   obj.restart(iter_sup,fcall_sup)
% 
% if not specified, iter_sup and fcall_sup are set to 50.

% parser
p = inputParser;
p.KeepUnmatched = true;
p.PartialMatching = false;
p.addOptional('iter_sup',50,@(x)(x == floor(x))&&(isempty(x)||isscalar(x)));
p.addOptional('fcall_sup',50,@(x)(x == floor(x))&&(isempty(x)||isscalar(x)));
p.parse(iter_sup, fcall_sup)
in = p.Results;

obj.display_temp = obj.prob.display;
obj.prob.display = false;

if isa( obj.prob , 'Problem_multifi')
    
    obj.prob.prob_HF.display = false;
    obj.prob.prob_LF.display = false;
    
end

obj.iter_max = obj.iter_num + in.iter_sup;
obj.fcall_max = obj.fcall_max + in.fcall_sup;

% Reset flags
obj.failed=false;
obj.opt_stop=false;
obj.crit_stop=false;

obj.Opt();

end





% ==========================================================================
%
%    This file is part of SBDOT.
%
%    SBDOT is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    SBDOT is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with SBDOT.  If not, see <http://www.gnu.org/licenses/>.
%
%    Use of SBDOT is free for personal, non-profit, pure academic research
%    and educational purposes. Restrictions apply on commercial or funded
%    research use. Please read the IMPORTANT_LICENCE_NOTICE file.
%
% ==========================================================================


