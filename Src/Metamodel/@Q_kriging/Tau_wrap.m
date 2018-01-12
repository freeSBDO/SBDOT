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


