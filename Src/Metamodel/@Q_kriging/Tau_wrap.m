function Tau = Tau_wrap( obj, Tau_0, m_t, type, D_chol)
    % TAU_WRAP wraps the different builds (Build_tau method) for each
    % modality
    %
    %   Inputs:
    %       obj is an object of class Q_kriging
    %       Tau_0 are hyperspheric coordinates for tau
    %       m_t are modalities number of levels
    %       type is tau decomposition type
    %       D_chol are heteroskedastic values
    %
    %   Output:
    %       Tau contains the cartesian coordinates for tau
    %
    % Syntax :
    % Tau = obj.Tau_wrap( Tau_0, m_t, type, D_chol );
    
    Id_Tau = [1, cumsum(arrayfun(@(k) sum(1:k), m_t-1))];
    Id_Tau = [(Id_Tau(1:(end-1))+[0,ones(1,(length(m_t)-1))]); Id_Tau(2:end)];

    if strcmp(type, 'isotropic')
        
        Tau = cell2mat(arrayfun(@(k) obj.Build_tau(Tau_0(k), m_t(k), type, []),...
                                1:length(m_t), 'UniformOutput', false)');
        
    elseif strcmp(type, 'choleski')
        
        Tau = cell2mat(arrayfun(@(k) obj.Build_tau(Tau_0(Id_Tau(1,k):Id_Tau(2,k)), m_t(k), type, []),...
                                1:length(m_t), 'UniformOutput', false)');
        
    else
        
        Id_Chol = cumsum([1,m_t]);
        Id_Chol = [Id_Chol(1:(end-1));Id_Chol(1:(end-1))+m_t-1];
        Tau = cell2mat(arrayfun(@(k) obj.Build_tau(Tau_0(Id_Tau(1,k):Id_Tau(2,k)), m_t(k), type ,D_chol(Id_Chol(1,k):Id_Chol(2,k))),...
                                1:length(m_t), 'UniformOutput', false)');
        
    end
    
end