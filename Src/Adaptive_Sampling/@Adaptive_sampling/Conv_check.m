function [] = Conv_check( obj )
    % CONV_CHECK Check failure or fcall/iteration max
    %
    % Syntax :
    %   obj.Conv_check()

    
    if ~isempty(obj.iter_num) && ( obj.iter_num == obj.iter_max )
        
        obj.opt_stop = true;
        fprintf('Optimization completed because maximum number of iterations is reached.\n\n');
        
    end
    
    if obj.fcall_num >= obj.fcall_max
        
        obj.opt_stop = true;
        fprintf('Optimization completed because maximum number of function calls is reached.\n\n');
    
    end

end

