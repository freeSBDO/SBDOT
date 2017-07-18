function p_tau = Preproc_tau (obj,dist_idx_psi,m_t,n_x,tau_sph,q1,q2,tau_type,hyp_dchol)
    % PREPROC_TAU is preprocessing tau coefficients in hyp_tau regarding
    % dist_idx (i.e. points' IDs where correlation is desired)
    %
    %   Inputs:
    %       obj is an object of class Q_kriging
    %       dist_idx_psi contains points' IDs
    %       m_t contains qualitative variables number of levels
    %       n_x contains number of points in the DoE
    %       tau_sph contains tau coefficients in hypershperic coordinates
    %       q1 contains corresponding qualitative values (to x1 IDs levels)
    %       q2 contains corresponding qualitative values (to x2 IDs levels)
    %       tau_type type of intra modality decomposition
    %       hyp_dchol contains heteroskedasticity values
    %
    %   Output:
    %       p_tau contains preprocessed tau coefficients
    %
    % Syntax :
    % p_tau = obj.Preproc_tau( dist_idx_psi, m_t, n_x, hyp_tau, [], [], tau_type, hyp_dchol );
    % p_tau = obj.Preproc_tau( dist_idx_psi, m_t, n_x, hyp_tau, [], q2, tau_type, hyp_dchol );
    % p_tau = obj.Preproc_tau( dist_idx_psi, m_t, [], hyp_tau, q1, q2, tau_type, hyp_dchol );
    
    if (~isempty(n_x) && (isempty(q1) || isempty(q2)))

        if isempty(q1) && isempty(q2)

            q = zeros(size(dist_idx_psi,1),2*length(m_t));
            n_x = [0,cumsum(n_x)];

            for i = 1:(length(n_x)-1)
                c = and(dist_idx_psi<=n_x(i+1),dist_idx_psi>n_x(i));
                temp = ind2subVect(m_t,i);
                q(c(:,1),1:length(m_t)) = repmat(temp,sum(c(:,1)),1);
                q(c(:,2),(length(m_t)+1):(2*length(m_t))) = repmat(temp,sum(c(:,2)),1);
            end   

        else

            q2 = zeros(size(dist_idx_psi,1),length(m_t));
            n_x = [0,cumsum(n_x)];

            for i = 1:(length(n_x)-1)
                c2 = and(dist_idx_psi(:,2)<=n_x(i+1),dist_idx_psi(:,2)>n_x(i));
                q2(c2,:) = repmat(ind2subVect(m_t,i),sum(c2),1);
            end

            q = [q1, q2];

        end

    end

    Tau_Cart = obj.Tau_wrap(tau_sph, m_t,tau_type,hyp_dchol);
    Ind = zeros(length(q),length(m_t));
    l = [0, cumsum(m_t.*(m_t+1)/2)];

    for i = 1:length(m_t)
        c = q(:,i)>q(:,i+length(m_t));
        q(c,[i,i+length(m_t)]) = q(c,[i+length(m_t),i]);
        Ind(:,i) = l(i) + sub2tril([q(:,i+length(m_t)),q(:,i)],m_t(i));
    end

    p_tau = prod(Tau_Cart(Ind),2);
    
end