function [ y_eval, g_eval, x_eval ] = Eval( obj, x_eval, which_pb )
    % EVAL Evaluates the problem function at x_eval
    %   *x_eval is a n_eval by m_x matrix
    %
    % Syntax :
    % []=obj.Eval(x_eval, which_pb);

    switch which_pb
        
        case 'HF'
            
            [ y_eval, g_eval, x_eval ] = obj.prob_HF.Eval( x_eval );
            
        case 'LF'
            
            [ y_eval, g_eval, x_eval ] = obj.prob_LF.Eval( x_eval );
            
        case 'ALL'
            
            obj.prob_LF.Eval( x_eval );
            [ y_eval, g_eval, x_eval ] = obj.prob_HF.Eval( x_eval );
            
            
        otherwise
            
            error( 'SBDOT:Eval_multifi:which_pb',...
                ['You specified a wrong problem to evaluate, ',...
                'choose between ''HF'', ''LF'' or ''ALL''.'] )
            
    end
    
end

