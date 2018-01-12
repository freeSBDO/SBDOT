function [] = Conv_check_crit( obj )
% CONV_CHECK_CRIT Checks for convergence criterion
% None here

obj.Find_min_value();

if obj.display_temp
    fprintf( [sprintf(['[%3.0i]    %6.2e    %6.2e       (',...
        repmat('%.6g ',1,obj.prob.m_x),'\b)'],...
        obj.iter_num, obj.y_min, obj.gutmann_val, obj.x_new), '\n'] )
end

% History update
obj.hist.crit = [ obj.hist.crit ; obj.gutmann_val ]; 

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


