function [] = Conv_check_crit( obj )
% CONV_CHECK_CRIT Checks for convergence criterion
%

obj.Find_min_value();

if obj.display_temp
    fprintf( [sprintf(['[%3.0i]    %6.2e    %6.2e       (',...
        repmat('%.6g ',1,obj.prob.m_x),'\b)'],...
        obj.iter_num, obj.y_min, obj.Gutmann_val, obj.x_new), '\n'] )
end

% History update
obj.hist.crit = [ obj.hist.crit ; obj.Gutmann_val ]; 

end

