function [] = Opt( obj )
    % OPT Launch optimization process
    %
    % Syntax :
    % obj.Opt();

    if obj.display_temp
        
        fprintf('[iter]     min_y     Criterion     Point added \n');
        
    end
    
    while ~obj.opt_stop && ~obj.failed
        
        try
            
            obj.iter_num = obj.iter_num + 1;
            
            obj.Conv_check(); % Check convergence
            obj.Opt(); % Main method (in subclass)            
            obj.Eval(); % Evaluation
            
        catch ME
            
            obj.failed = true;
            obj.opt_stop = true;
            obj.error = ME;
            disp(ME.message)
            warning('off','backtrace')
            warning('Check obj.error for more information !')
            
        end
    end
    
    % Display back to its normal value
    obj.prob.display = obj.display_temp;
    if class(obj.prob) == 'Problem_multifi'
        obj.prob.prob_HF.display = obj.display_temp;
        obj.prob.prob_LF.display = obj.display_temp;
    end
    
end

