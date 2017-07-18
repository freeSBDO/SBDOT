function [mean, variance] = Predict_comp( obj, x_eval, q_eval )

    n_eval = size(x_eval, 1);
	m_x = obj.prob.m_x;
    Q_var = x_eval(:,(m_x+1):end);
    x_eval = x_eval(:,1:m_x);
    
	% Regression function	
    F = obj.Regression_matrix( [x_eval, Q_var] );
    polmean = F * obj.alpha;
	
    % GP part
    % distance matrix
    corr = obj.Ext_corr(x_eval,q_eval);
    
    if obj.optim_idx(1, obj.SIGMA2)
        gp = (obj.hyp_sigma2 * corr) * obj.gamma;
    else
        gp = corr * obj.gamma;
    end
    
    % prediction
    mean = polmean + gp;
	
    % Calculate sigma
    if nargout > 1
        
        % Reinterpolation
        if obj.reinterpolation
            
            corrt = obj.C_reinterp \ corr';
            
            u = obj.Ft_reinterp.' * corrt - F.';
            v = obj.R_reinterp \ u;
            tmp = (1 + sum(v.^2,1) - sum(corrt.^2,1))';
            
            variance = repmat(obj.sigma2_reinterp,n_eval,1) .* repmat(tmp,1,length(obj.sigma2_reinterp));
            
        elseif strcmpi(obj.tau_type, 'heteroskedastic')
            
            ind = cumsum(obj.prob.m_t);
            ind = uint8([ 0, ind(1:(end-1)) ]);
            q_eval =  uint8(q_eval) + repmat(ind, size(q_eval,1), 1);

            Tau_Cart = obj.Tau_wrap( obj.hyp_tau', obj.prob.m_t, obj.tau_type, obj.hyp_dchol );
            
            D = zeros(sum(obj.prob.m_t), 1);
            ind_2 = cumsum( obj.prob.m_t.*(obj.prob.m_t+1)/2 );
            ind_2 = [ [1,ind_2(1:(end-1))+1]; ind_2 ];
            for i = 1:length(obj.prob.m_t)
                m = obj.prob.m_t(i);
                D((ind(i)+1):ind(i)+m) = diag( vect2tril( [m, m], Tau_Cart(ind_2(1, i):ind_2(2, i)), 0 ) );
            end
            
            D = prod( D(q_eval), 2);
            
            corrt = obj.C \ corr';
            
            u = obj.Ft.' * corrt - F.';
            v = obj.R \ u;
            
            variance = obj.hyp_sigma2 * (D' + sum(v.^2,1) - sum(corrt.^2,1))';
            
        else
            
            corrt = obj.C \ corr';
            
            u = obj.Ft.' * corrt - F.';
            v = obj.R \ u;
            
            tmp = (1 + sum(v.^2,1) - sum(corrt.^2,1))';
            variance = (obj.hyp_sigma2 * ones(n_eval,1)) .* tmp;
            
        end
        
    end
    
end
