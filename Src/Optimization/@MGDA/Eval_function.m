function [ y_eval, grad_eval ] = Eval_function( obj, x_eval )
% Evaluate the function file at x_eval
%
% Get the gradient or estimates it by forward finite difference
%
% Syntax:
%   [y_eval,grad_eval]=obj.eval_function(x_eval)

% Prepare input for finite difference
if ~obj.grad_available && nargout > 1
    
    x_finite_diff = obj.Get_x_finite_diff( x_eval );
    x_eval = [ x_eval ; x_finite_diff ];
    
end

try
    
    if obj.grad_available % Gradient available
        
        [ y_eval, grad_eval ] = feval( obj.function_name, x_eval );
        
    else
        
        if obj.parallel % Evaluation of multiple points is available with the function file
            y_eval = feval( obj.function_name, x_eval );
        else % For loop is needed for evaluation
            for i = 1:size(x_eval,1)
                y_eval(i,:) = feval( obj.function_name, x_eval(i,:) );
            end
        end
        
    end
    
    if ~obj.grad_available && nargout > 1 % Gradient estimation
        
        grad_eval = bsxfun( @rdivide,...
            bsxfun( @minus, y_eval(2:end,:), y_eval(1,:) ),...
            obj.finite_diff_step' );
        
    end
    
    obj.f_call = obj.f_call+1; % Count the number of function calls
    
catch ME % Evaluation error...
    
    obj.failed = true;
    obj.error = ME;
    warning(['Evaluation failed at x=',num2str(x_eval(1,:))],...
        ', check obj.error for more information.')
    
end

end