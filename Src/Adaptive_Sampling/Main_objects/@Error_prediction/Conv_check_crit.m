function [] = Conv_check_crit( obj )
%CONV_CHECK_CRIT Checks for convergence criterion
%   None here

% Convergence criterion update
obj.hist.crit = [ obj.hist.crit ; obj.error_value ];

% Display
if obj.display_temp
    fprintf( [sprintf(['[%3.0i]   [Not disp]    %6.2e       (',...
        repmat('%.6g ',1,obj.prob.m_x),'\b)'],...
        obj.iter_num, obj.error_value, obj.x_new), '\n'] )
end

end

