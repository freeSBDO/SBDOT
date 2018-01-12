function [ x_rob ] = X_to_rob( obj, x)
% X_TO_ROB
% Prepare x for mse evaluation
% Environmental variables are set to their nominal values

for i = 1:obj.prob.m_x
    
    switch obj.unc_type{i}
        
        case {'uni','gauss'}
            
            if obj.env_lab(i)
                x_rob(:,i) = (obj.prob.lb(i) + obj.prob.ub(i))/2;
            else
                x_rob(:,i) = x(:,i);
            end
            
        case {'det'}
            
            x_rob(:,i) = x(:,i);
            
    end
    
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


