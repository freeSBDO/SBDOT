function [obj, err] = Update_sto ( obj, hp )
    % UPDATE_STO updates the stochastic part of the kriging according to
    % hyperparameters hp
    %
    %   Inputs:
    %       obj is an object of class Q_kriging
    %       hp are the values for hyperprameters
    %
    %   Output:
    %       obj is the updated input obj
    %       err is the error thrower
    %
    % Syntax :
    % [obj, err] = Update_sto ( obj, hp )
    
	err = [];
    
    % store new set of model parameters

    if obj.optim_idx(:,obj.REG)
        obj.hyp_reg = hp{:,obj.REG};
    end
    
    if obj.optim_idx(:,obj.SIGMA2)
        obj.hyp_sigma2 = hp{:,obj.SIGMA2};
    end
    
    if obj.optim_idx(:,obj.CORR)
        obj.hyp_corr = hp{:,obj.CORR};
    end
    
    if obj.optim_idx(:,obj.TAU)
        obj.hyp_tau = hp{:,obj.TAU};
    end
    
    if obj.optim_idx(:,obj.DCHOL)
        obj.hyp_dchol = hp{:,obj.DCHOL};
    end
    
    obj.p_tau = obj.Preproc_tau(obj.dist_idx_psi,obj.prob.m_t,obj.prob.n_x,obj.hyp_tau',[], [], obj.tau_type, obj.hyp_dchol);
    
    % Calculate extrinsic/intrinsic matrices
    psi = obj.Ext_corr(); % GP
    Sigma = obj.Int_cov(); % noise GP
    
    % Stochastic kriging:
    % if Sigma is a covariance matrix then sigma2 must be available and we store a covariance matrix
    
    if obj.optim_idx(1,obj.SIGMA2)
        % psi is covariance matrix
        psi = psi.*10.^hp{:,obj.SIGMA2} + Sigma;
    else
        % psi is correlation matrix
        psi = psi + Sigma;
    end
    
    % store intrinsic cov/corr matrix
    obj.Sigma = Sigma;

    % Cholesky factorization with check for pos. def.
    psi = psi + triu(psi,1)';
    [C, rd] = chol(psi);

    if rd > 0 % not positive definite
        err = 'correlation matrix is ill-conditioned.';
        return;
    end
    
	obj.C = C';

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


