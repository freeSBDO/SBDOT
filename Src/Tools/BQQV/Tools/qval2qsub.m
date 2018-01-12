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


