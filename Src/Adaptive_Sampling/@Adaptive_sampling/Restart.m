function [] = Restart( obj, iter_sup, fcall_sup )
%RESTART Restart an optimization sequence
% Syntax :
%   obj.Restart()
%   obj.restart(iter_sup,fcall_sup)


obj.display_temp = obj.prob.display;
obj.prob.display = false;

if isa( obj.prob , 'Problem_multifi')
    
    obj.prob.prob_HF.display = false;
    obj.prob.prob_LF.display = false;
    
end

if nargin == 0
    
    obj.iter_max = 50 + obj.iter_num;
    obj.fcall_max = 50 + obj.fcall_num;
    
else
    
    obj.iter_max = obj.iter_num + iter_sup;
    obj.fcall_max = obj.fcall + fcall_sup;
    
end

objEGO.failed=false;
objEGO.opt_stop=false;
objEGO.crit_stop=false;

objEGO.opt();

end

