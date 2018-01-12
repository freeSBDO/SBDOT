function [] = Total_comp( obj )
% TOTAL_COMP
% Computes Sobol total indices
% See Table 2 formula (f)[Saltelli et. al. 2009]

if obj.total == 1
    
    for i = 1:obj.m
        
        x_stot = obj.samp_A;
        x_stot(:,i) = obj.samp_B(:,i);
        
        if isa(obj.func_obj,'Problem')
            y_stot = obj.func_obj.Eval( x_stot );
            obj.func_obj.x = [];
            obj.func_obj.y = [];
            obj.func_obj.g = [];
        else % Metamodel
            y_stot = obj.func_obj.Predict( x_stot );
        end
        
        % formula (f) of ref
        s_tot(i) = mean( (obj.y_A - y_stot) .^ 2 );
        
    end
    
    obj.s_tot = s_tot / ( 2*  obj.y_var );
    
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


