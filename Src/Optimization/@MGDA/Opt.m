function [] = Opt( obj )
% OPT
%   Run the MGDA algorithm at x_start

if obj.display
    fprintf('[iter]    y\n')
end

% Main loop
while ~obj.stop_opt && ~obj.failed && obj.iter <= obj.iter_max
    
    obj.iter = obj.iter + 1;
    
    % Eval output and gradient at the current input point
    [obj.y_iter , obj.grad_iter] = obj.Eval_function(obj.x_iter); 
    
    obj.hist.x = [ obj.hist.x ; obj.x_iter ];
    obj.hist.y = [ obj.hist.y ; obj.y_iter ];
    
    % Estimates shared descent direction
    grad_shared = obj.Get_grad_shared( obj.grad_iter ); 
    norm_grad_iter = sqrt( sum( obj.grad_iter.^2, 1 ) );
    
    % Initialize step optimization
    obj.step_current = min( norm_grad_iter );
    obj.stop_step = false; 
    
    % Step optimization loop
    while ~obj.stop_step
        
        % next point to be evaluated
        x_next = obj.x_iter - obj.step_current * grad_shared'; 
        
        if norm(obj.x_iter-x_next) < 1e-4 % descent vector is too low
            
            obj.stop_opt=true;
            obj.stop_step=true;
            
            if obj.display
                fprintf('Shared descent vector is too low, optimization is stopped.\n')
            end
            
        else
            
            % check if next input is inside bounds
            if any(x_next>obj.ub) || any(x_next<obj.lb) 
                
                % Put out of bound values at bound
                x_next( x_next > obj.ub ) = obj.ub( x_next > obj.ub ); 
                x_next( x_next < obj.lb ) = obj.lb( x_next < obj.lb ) ; 
                
            end
            
            % Eval next point
            [ y_next, grad_next ] = obj.Eval_function( x_next ); 
            
            % Check if output value has decreased            
            test_armijo = all( y_next(1,:) <= obj.y_iter(1,:) ); 
            % If not, reduce the step => new step is 10% of the previous one            
            if test_armijo 
                obj.stop_step = true;
            else
                obj.step_current = 0.1 * obj.step_current;
            end
            
        end
        
    end
    
    if ~obj.stop_opt % Store history and set next point to current point
        
        if obj.display
            fprintf([sprintf(['[%3.0i]    ',repmat('%.6g ',1,size(obj.y_iter,2)),'\b'], ...
                obj.iter,obj.y_iter(1,:)),'\n'])
        end
        
        obj.x_iter = x_next;
        obj.y_iter = y_next;
        obj.grad_iter = grad_next;
    end
    
    if obj.iter >= obj.iter_max
        
        obj.stop_opt = true;
        
        if obj.display
            fprintf('Maximum iteration number is reached, optimization is stopped.\n')
        end
        
    end
    
end

obj.x_min = obj.x_iter( end, : );
obj.y_min = obj.y_iter( end, : );

end

