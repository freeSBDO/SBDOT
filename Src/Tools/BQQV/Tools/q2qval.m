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


