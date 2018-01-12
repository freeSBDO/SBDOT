function [] = Partial_comp( obj )
% PARTIAL_COMP
% Computes Sobol partial indices
% See Table 2 formula (b)[Saltelli et. al. 2009]

if obj.partial ~= 0
    
    % Number of partial indices
    for i = 1:size( obj.M, 1 )
        
        % j corresponds to input which partial indices are computed
        j = find( obj.M(i,:) );
        
        if length(j) == 1 || obj.partial == 2
            
            x_si = obj.samp_A;
            x_si(:,j) = obj.samp_B(:,j);
            
            if isa(obj.func_obj,'Problem')
                y_si = obj.func_obj.Eval( x_si );
                obj.func_obj.x = [];
                obj.func_obj.y = [];
                obj.func_obj.g = [];
            else % Metamodel
                y_si = obj.func_obj.Predict( x_si );
            end
            
            % formula (b) of ref
            s_i(i) = mean( obj.y_B .* (y_si - obj.y_A) );
            
            if length(j) > 1 &&  s_i(i)~=0 % Higher order computation
                s_i(i) = s_i(i) - sum( s_i(j) ); % Remove first order influence
            end
            
        end
        
    end
    
    % Sobol partial indice
    obj.s_i = s_i / obj.y_var;
    
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


