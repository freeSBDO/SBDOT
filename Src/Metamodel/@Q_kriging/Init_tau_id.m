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


