function obj = Update_model( obj, F, hp )
    % UPDATE_MODEL updates the overall model (applying Update_sto and Update_reg).
    %
    %   Inputs:
    %       obj is an object of class Q_kriging
    %       F is the regression matrix
    %       hp contains the values of hyperparameters
    %
    %   Output:
    %       obj is the updated input obj
    %
    % Syntax :
    %   obj = obj.Update_model( F, hp );
    
	% correlation
	[obj, err] = obj.Update_sto( hp );
	if ~isempty( err )
		error(['Q_kriging:Update_model:' err '(Update_sto)']);
	end
	
	% regression (get least squares solution)
	[obj, err] = obj.Update_reg( F, hp );
    if ~isempty( err )
        error(['Q_kriging:Update_model:' err '(Update_reg)']);
    end
    
    % reinterpolation (Forrester2006)
    if obj.reinterpolation
        
       obj.C_reinterp = chol( obj.C*obj.C' - obj.Sigma )';
       
       obj.Ft_reinterp = obj.C_reinterp \ F;
       [~, obj.R_reinterp] = qr(obj.Ft_reinterp,0);
       
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


