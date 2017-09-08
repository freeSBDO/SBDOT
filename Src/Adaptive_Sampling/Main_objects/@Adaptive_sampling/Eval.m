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
        if isa( obj.prob , 'Q_problem')
            
            q_val = arrayfun(@(k) obj.prob.t{k}(ind2subVect(obj.prob.m_t,obj.x_new(obj.prob.m_x+1))), 1:length(obj.prob.m_t));
            num_x = zeros(1,prod(obj.prob.m_t));
            num_x(obj.x_new(obj.prob.m_x+1)) = 1;
            [ y_eval, g_eval, x_eval ] = obj.prob.Eval( num_x, [obj.x_new(1:obj.prob.m_x), q_val] );
            
        elseif isa( obj.prob , 'Problem_multifi')
            
            [ y_eval, g_eval, x_eval ] = obj.prob.Eval( obj.x_new, obj.eval_type );
            
        else
            
            [ y_eval, g_eval, x_eval ] = obj.prob.Eval( obj.x_new );
            
        end
        
        obj.x_new = x_eval;
        y_new = y_eval( :, obj.y_ind );
        g_new = g_eval( :, obj.g_ind );

        % Update objective training dataset, kriging and history
        obj.hist.x = [ obj.hist.x ; obj.x_new ];
        
        if obj.m_y >= 1
            
            for i = 1 : obj.m_y
                
                obj.meta_y(i,:).Clean({'all'});
                obj.meta_y(i,:).Train();
                
            end
            
            obj.hist.y = [ obj.hist.y ; y_new ];
            
        end    

        % Update constraint...
        if obj.m_g >= 1
            
            for i = 1 : obj.m_g
                
                obj.meta_g(i,:).Clean({'all'});
                obj.meta_g(i,:).Train();
                
            end
            
            obj.hist.g = [ obj.hist.g ; g_new ];
            
        end

        obj.fcall_num = obj.fcall_num + size(x_eval,1);
        
    catch ME
        
        obj.failed = true;
        warning('off','backtrace')
        warning('Optimization stops prematurely during evaluation of the problem function !')
        warning(ME.message);
        fprintf(['Optimization failed at iteration ',num2str(obj.iter_num),' !\n\n']);
        
    end

end


