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
obj.fcall_max = obj.fcall + in.fcall_sup;

% Reset flags
objEGO.failed=false;
objEGO.opt_stop=false;
objEGO.crit_stop=false;

objEGO.opt();

end

