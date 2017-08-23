function [] = Conv_check_crit( obj )
% CONV_CHECK_CRIT Checks for convergence criterion
% EI  / y_min <= Tol_conv on Tol_inarow successive iterations

% Convergence criterion update
obj.conv_crit = abs( obj.EI_val / obj.y_min );

if obj.conv_crit <= obj.Tol_conv
    
    % +1 succesive Tol_conv iterations
    obj.in_a_row = obj.in_a_row + 1 ;
    
    if obj.in_a_row == obj.Tol_inarow
        
        obj.crit_stop = true;
        fprintf('Optimization completed because EI criterion converged.\n\n');
    else
        % Display
        if obj.display_temp
            fprintf( [sprintf(['[%3.0i]    %6.2e    %6.2e       (',...
                repmat('%.6g ',1,obj.prob.m_x),'\b)'],...
                obj.iter_num, obj.y_min, obj.conv_crit, obj.x_new), '\n'] )
        end
    end
else
    
    % reset succesive Tol_conv iterations
    obj.in_a_row = 0;
    
    % Display
    if obj.display_temp
        fprintf( [sprintf(['[%3.0i]    %6.2e    %6.2e       (',...
            repmat('%.6g ',1,obj.prob.m_x),'\b)'],...
            obj.iter_num, obj.y_min, obj.conv_crit, obj.x_new), '\n'] )
    end
end

% History update
obj.hist.crit = [ obj.hist.crit ; obj.conv_crit ]; 

end

