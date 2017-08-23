function [] = Restart( obj, iter_sup )
% RESTART
% Restart an optimization sequence with 50 generations or an user defined nummber
%
% Syntax :
%   objEGO.restart()
%   objEGO.restart(iter_sup)

if nargin==0
    
    obj.max_gen = 10 + obj.max_gen ;
    
else
    
    obj.max_gen = obj.max_gen + iter_sup;
    
end

obj.Domination_sorting();
obj.Opt();

end

