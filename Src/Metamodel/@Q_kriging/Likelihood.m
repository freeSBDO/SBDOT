function out = Likelihood( obj, F, hp )
    % LIKELIHOOD computes the likelihood associated to kriging
    %
    %   Inputs:
    %       obj is an object of class Q_kriging
    %       F is the regression matrix
    %       hp contains the values of hyperparameters on which the function is evaluated
    %
    %   Output:
    %       out returns the value of the likelihood function
    %
    % Syntax :
    %   out = Likelihood( obj, F, hp );
    
    if size(hp,1)==1
        hp = hp';
    end
    
    param = {obj.hyp_reg, obj.hyp_sigma2, obj.hyp_corr, obj.hyp_tau, obj.hyp_dchol};
    param(1, obj.optim_idx) = mat2cell( hp', 1, obj.optim_nr_parameters );

    
	% correlation
	[obj, err] = obj.Update_sto ( param );
    
    if ~isempty(err)
        out = +Inf;
        return;
    end
    
	% regression (get least squares solution)
	[obj, err] = obj.Update_reg ( F, param );
    
	if ~isempty(err)
		out = +Inf;
		return;
	end

    % likelihood
    out = feval( obj.marginal_likelihood, obj );
    
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


