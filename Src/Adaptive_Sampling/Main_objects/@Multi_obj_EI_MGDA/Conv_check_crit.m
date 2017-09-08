function [] = Conv_check_crit( obj )
% CONV_CHECK_CRIT Checks for convergence criterion
% 0 points added on Tol_inarow successive iterations

obj.Find_min_value();

if obj.conv_crit == 0
    
    % +1 succesive Tol_conv iterations
    obj.in_a_row = obj.in_a_row + 1 ;
    
    if obj.in_a_row == obj.Tol_inarow
        
        obj.crit_stop = true;
        fprintf('Optimization completed because no points added.\n\n');
    else
        % Display
        if obj.display_temp
            if isempty(obj.x_new)
                x_new_disp = nan(1,obj.prob.m_x);
            else
                x_new_disp = obj.x_new(1,:);
            end
            fprintf( [sprintf(['[%3.0i]   %6.2e    %6.2e       (',...
                repmat('%.6g ',1,obj.prob.m_x),'\b)'],...
                obj.iter_num, obj.y_min, obj.conv_crit, x_new_disp), '\n'] )
        end
    end
else
    
    % reset succesive Tol_conv iterations
    obj.in_a_row = 0;
    
    % Display
    if obj.display_temp
        fprintf( [sprintf(['[%3.0i]   %6.2e    %6.2e       (',...
            repmat('%.6g ',1,obj.prob.m_x),'\b)'],...
            obj.iter_num, obj.y_min, obj.conv_crit, obj.x_new(1,:)), '\n'] )
    end
end

% History update
obj.hist.crit = [ obj.hist.crit ; obj.conv_crit ]; 

end

