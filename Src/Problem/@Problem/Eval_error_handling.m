function [] = Eval_error_handling( obj, ME, x_eval )
    %EVAL_ERROR_HANDLING Throw custom errors
    %   *ME is the error object
    %   *x_eval is the input vector that failed
    %
    % Syntax :
    % obj.Eval_error_handling( ME, x_eval );

    switch ME.identifier
        
        case 'MATLAB:UndefinedFunction'
            
            throw(MException('SBDOT:Problem:eval_failed', ...
                ['Evaluation failed at x = [',num2str(x_eval),']\n', ...
                ME.message,...
                'Check function_name variable or ensure that your function is in the Matlab path']));
        
        case 'MATLAB:maxlhs'
            
            throw(MException('SBDOT:Problem:eval_failed', ...
                ['Evaluation failed at x = [',num2str(x_eval),']\n', ...
                'Your evaluation function only have one or less output argument but you set the number of constraints to ',num2str(obj.m_g),'.\n', ...
                'Change your evaluation function by adding an output argument for constraints or set m_g variable to 0']));
        
        otherwise
            
            throw(MException('SBDOT:Problem:eval_failed', ...
                ['Evaluation failed at x = [',num2str(x_eval),']\n', ...
                ME.message, '\n', ...
                ME.stack(1).file,'\n', ME.stack(1).name,'\n', num2str(ME.stack(1).line)]));
            
    end
    
end

