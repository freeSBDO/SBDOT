function Tau = Init_tau_id(obj)
    % INIT_TAU_ID initialize hyperspheric tau so that its cartesian coordinates gives the Identity
    %
    %   Inputs:
    %       obj is an object of class Q_kriging
    %
    %   Output:
    %       Tau is the initialized hypersheric coordinates of hyp_tau_0
    %
    % Syntax :
    % Tau = obj.Init_tau_id();

    m_t = obj.prob.m_t;
    type = obj.tau_type;

    if strcmp(type, 'choleski') || strcmp(type, 'heteroskedastic')
        
        temp = arrayfun(@(k) (pi/2)*ones(k-1), m_t, 'UniformOutput',false);
        Tau = cell2mat(cellfun(@(k) k(tril(true(size(k)))), temp, 'UniformOutput', false)');
        
    else
        
        Tau = 0.5*ones(length(m_t),1);
        
    end
    
end



