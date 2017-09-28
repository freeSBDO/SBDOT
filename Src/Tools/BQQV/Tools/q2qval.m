function q_val = q2qval( t, m_t, q )
    % Q2QVAL generates the qualitative values corresponding to the
    % input qualitative index or qualitative subscripts 
    %
    %   Inputs:
    %       t cell of qualitative values (typically Q_problem.t)
    %       m_t row containing the number of levels per qualitative
    %       variables (typically Q_problem.m_t)
    %       q column of qualitative index or matrix of qualitative
    %       subscripts
    %
    %   Output:
    %       q_val matrix of qualitative values
    %
    % Syntax :
    % q_val = q2qval( t, m_t, q );
    
    q = uint8(q);
    
    if size(q,2) == 1
        
        assert( all ( q <= prod(m_t).*ones(size(q,1),1) ),...
            'SBDOT:Tools:q2qval', ...
            'Index for qualitative evaluation shall be positive integer column lower than prod(m_t)');        
        
        if length(m_t) >1
            q = ind2subVect( m_t, q' );
        end
        
    else
        
        assert( size(q, 2) == length(m_t),...
            'SBDOT:Tools:q2qval',...
            'q shall either be a single column of index of size(x_eval, 1) or a matrix of subsctips of size(x_eval, 1) x length(m_t)');
        
        
        assert( all( all( q <= repmat(m_t,size(q,1),1) ) ),...
            'SBDOT:Tools:q2qval', ...
            'q subscripts shall be within the number of levels in m_t');
        
    end
    
    q_val = cell2mat(arrayfun(@(k) t{k}(q(:,k)), 1:length(m_t), 'UniformOutput', false));

end