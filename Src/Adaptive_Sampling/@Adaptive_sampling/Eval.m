function [] = Eval( obj )
    % EVAL Evaluate the problem at obj.x_new and update the metamodel
    %
    % Syntax :
    %   obj.eval_function()

    try
        
        % Trim x_new before evaluation
        if ~isempty(obj.fcall_max)
            
            fcall_left = obj.fcall_max - obj.fcall_num;
            
            if size( obj.x_new, 1 ) > fcall_left
                
                obj.x_new( fcall_left+1 : end, : ) = [];
                
            end
        end

        % Evaluation
        if isa( obj.prob , 'Problem_multifi')
            
            [ y_eval, g_eval, x_eval ] = obj.prob.Eval( obj.x_new, obj.eval_type );
            
        else
            
            [ y_eval, g_eval, x_eval ] = obj.prob.Eval( obj.x_new );
            
        end
        
        obj.x_new = x_eval;
        y_new = y_eval( :, obj.y_index );
        g_new = g_eval( :, obj.g_index );

        % Update objective training dataset, kriging and history
        for i = 1 : obj.m_y
            
            obj.meta_y(i,:).Train();
            
        end
        obj.hist.x = [ obj.hist.x ; obj.x_new ];
        obj.hist.y = [ obj.hist.y ; y_new ];

        % Update constraint...
        if obj.m_g >= 1
            
            for i = 1 : obj.m_g
                
                obj.meta_g(i,:).Train();
                
            end
            
            obj.hist.g = [ obj.hist.g ; g_new ];
            
        end

        obj.fcall_num = obj.fcall + size(x_eval,1);
        
    catch ME
        
        obj.failed = true;
        warning('off','backtrace')
        warning('Optimization stops prematurely during evaluation of the problem function !')
        warning(ME.message);
        fprintf(['Optimization failed at iteration ',num2str(obj.iter_num),' !\n\n']);
        
    end
    
    % Iteration convergence checking
    obj.Conv_check;

end


