function q = qval2qsub( t, m_t, q_val )
    % QVAL2QSUB generates the qualitative subscripts corresponding to the
    % input qualitative values 
    %
    %   Inputs:
    %       t cell of qualitative values (typically Q_problem.t)
    %       m_t row containing the number of levels per qualitative
    %       variables (typically Q_problem.m_t)
    %       q_val matrix of qualitative values
    %
    %   Output:
    %       q matrix of qualitative subscripts
    %
    % Syntax :
    % q = qval2qsub( t, m_t, q_val );
    
    t_validation = arrayfun(@(k) ~isempty(intersect(q_val(:,k), t{k})), 1:length(m_t) );
    
    assert( all ( t_validation ),...
    'SBDOT:qval2q:wrong_q_levels', ...
    'q_val levels are different from the ones reffered in t.');

    q = zeros(size(q_val));
    
    logic = @(k) cell2mat(arrayfun(@(l) logical(q_val(:,k)==t{k}(l)), 1:length(t{k}), 'UniformOutput', false));
    sub = @(k) ind2subVect(size(q_val),find(logic(k))');
    temp = cell2mat(arrayfun(@(k) sub(k), 1:length(m_t), 'UniformOutput', false ));
    
    for i = 1:size(q_val,2)
        q(temp(:,2*(i-1)+1),i) = temp(:,2*i);
    end
    
end