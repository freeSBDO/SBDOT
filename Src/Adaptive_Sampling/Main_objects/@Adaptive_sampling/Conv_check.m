function [] = Conv_check( obj )
    % CONV_CHECK Check failure or fcall/iteration max
    %
    % Syntax :
    %   obj.Conv_check()

    % iter max check
    if ~isempty(obj.iter_num) && ( obj.iter_num == obj.iter_max )
        
        obj.opt_stop = true;
        fprintf('Optimization completed because maximum number of iterations is reached.\n\n');
        
    end
    
    % fcall max check
    if obj.fcall_num >= obj.fcall_max
        
        obj.opt_stop = true;
        fprintf('Optimization completed because maximum number of function calls is reached.\n\n');
    
    end

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


