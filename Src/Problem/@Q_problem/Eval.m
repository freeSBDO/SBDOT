function [ y_eval, g_eval, x_eval ] = Eval( obj, num_x, x_eval )
    % EVAL Evaluates the problem function at x_eval
    %   
    %   Inputs:
    %   obj the object of class Q_problem
    %   num_x number of points per level-combination [number of level-combinations: prod(obj.m_t)]
    %   x_eval is a matrix or a cell containg the quantitative and qualitative VALUES [qualitative values in: obj.t]
    %
    %   Outputs:
    %   y_eval Evaluation of the response(s) on x_eval
    %   g_eval Evaluation of the constraint(s) on x_eval
    %   x_eval
    %
    % Syntax :
    % [ y_eval, g_eval ]=obj.Eval(num_x, x_eval);
    
    validateattributes( num_x, {'numeric'}, {'nonempty','row','nonnegative'})
    
    assert( or(size(num_x,2) == 1, size(num_x,2) == prod(obj.m_t)),...
        'SBDOT:Q_problem:sample_size_specifications',...
        'num_x shall either be of length equal to 1 or the number of qualitative combination')
    
    if size(num_x,2) == 1
        num_x = num_x*ones(1,prod(obj.m_t));
    end
    
    if isa(x_eval,'cell')
        x_mat = cell2mat(x_eval');
    else
        x_mat = x_eval;
    end
    
    % Checks
    n_eval = obj.Input_assert( x_mat );

    % Evaluation
    if obj.round
        x_mat( :, 1:obj.m_x ) = Round_data( x_mat( :, 1:obj.m_x ), obj.round_range ); %round x_eval
    end

    if obj.display, fprintf('Evaluation '); end

    if obj.parallel % Parallel evaluation is allowed

        if obj.display, fprintf('ongoing'); end

        try
            if obj.m_g > 0 % With constraints
                [ y_eval, g_eval ]=feval( obj.function_name, x_mat );
            else           % Unconstrained
                y_eval = feval( obj.function_name, x_mat );
                g_eval = [];
            end
        catch ME
            obj.Eval_error_handling( ME, 'unknow because parallel evaluation' )
        end
        
        if ~isempty(obj.save_file)
            
            save( obj.save_file, 'x_eval', 'y_eval', 'g_eval' )
            
        end

        if obj.display, fprintf( repmat('\b',1,7) ); end   

    else % Parallel evaluation is not allowed    

        if obj.display
            format_display = [ '%',num2str(length(num2str(n_eval))),...
                '.0d/%',num2str(length(num2str(n_eval))),'.0d' ];
            format_display2=repmat('\b',1,2*length(num2str(n_eval))+1); 
        end 

        y_eval = zeros(n_eval,obj.m_y);
        
        for i=1:n_eval
            if obj.display, fprintf( format_display, i, n_eval ); end

            try
                if obj.m_g > 0 % With constraints
                    g_eval = zeros(n_eval,obj.m_g);
                    [ y_eval(i,:), g_eval(i,:) ] = feval( obj.function_name, x_mat(i,:) );

                else           % unconstraint
                    y_eval(i,:) = feval( obj.function_name, x_mat(i,:) );
                    g_eval = [] ;
                end
            catch ME
                obj.Eval_error_handling( ME, x_mat(i,:) )
            end 
            
            if ~isempty(obj.save_file)
                
                save( obj.save_file, 'x_eval', 'y_eval', 'g_eval' )
                
            end

            if obj.display,fprintf( format_display2 ); end         

        end

    end

    if obj.display, fprintf( 'completed.\n\n' ); end

    obj.Add_data( x_mat, y_eval, g_eval, num_x); % add dataset to object

end

