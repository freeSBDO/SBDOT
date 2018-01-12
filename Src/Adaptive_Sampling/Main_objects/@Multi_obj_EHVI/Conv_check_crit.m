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





% ==========================================================================
%
%    This file is part of SBDOT.
%
%    SBDOT is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    SBDOT is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with SBDOT.  If not, see <http://www.gnu.org/licenses/>.
%
%    Use of SBDOT is free for personal, non-profit, pure academic research
%    and educational purposes. Restrictions apply on commercial or funded
%    research use. Please read the IMPORTANT_LICENCE_NOTICE file.
%
% ==========================================================================


