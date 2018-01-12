function [] = Check_pb( obj )
    % CHECK_PB Verify that high and low fidelity Problem have the same
    % parameters

    assert( obj.prob_LF.m_x == obj.prob_HF.m_x, ...
        'SBDOT:Problem_multify:dimension_input', ...
        'Input space dimension is different between HF and LF problem' );
    obj.m_x = obj.prob_LF.m_x;

    assert( obj.prob_LF.m_y == obj.prob_HF.m_y, ...
        'SBDOT:Problem_multify:dimension_objective', ...
        'Output space dimension for objective is different between HF and LF problem' );
    obj.m_y = obj.prob_LF.m_y;
    
    assert( obj.prob_LF.m_g == obj.prob_HF.m_g, ...
        'SBDOT:Problem_multify:dimension_constraint', ...
        'Output space dimension for constraint is different between HF and LF problem' );
    obj.m_g = obj.prob_LF.m_g;
    
    assert( all( obj.prob_LF.lb == obj.prob_HF.lb ), ...
        'SBDOT:Problem_multify:lb_difference', ...
        'Lower bound of input space is different between HF and LF problem' );
    obj.lb = obj.prob_LF.lb;
    
    assert( all( obj.prob_LF.ub == obj.prob_HF.ub ), ...
        'SBDOT:Problem_multify:ub_difference', ...
        'Upper bound of input space is different between HF and LF problem' );
    obj.ub = obj.prob_LF.ub;
    
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


