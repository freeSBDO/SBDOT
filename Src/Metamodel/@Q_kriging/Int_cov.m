function Sigma = Int_cov ( obj )
    % INT_COV computes the intrinsic covariance matrix
    %
    %   Inputs:
    %       obj is an object of class Q_kriging
    %
    %   Output:
    %       Sigma is the (usually) sparse intrisic covariance matrix
    %
    % Syntax :
    % Sigma = obj.Int_cov();
    
  if obj.optim_idx(:,obj.REG)
      
    n = size(cell2mat(obj.samples'), 1);
    o = (1:n)';

    reg = 10.^obj.hyp_reg( ones(n,1), 1 );
    Sigma = sparse( o, o, reg );
    
  else
      
    Sigma = obj.Sigma;
    
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


