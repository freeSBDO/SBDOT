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
    else
        obj.hyp_reg = 1; % Sigma is covariance matrix
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