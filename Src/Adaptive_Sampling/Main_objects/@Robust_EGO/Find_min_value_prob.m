function [] = Find_min_value_prob( obj )
% FIND_MIN_VALUE_PROB
% Find the actual minimum value of the optimization problem in the already evaluated points

[y_prob,~,g_prob,~] = obj.Eval_rob_meas(obj.prob.x(:,~obj.env_lab));

if obj.m_g>=1
    
    y_min_prob = min( y_prob( ...
        all( g_prob(:,obj.g_ind) <= 0 , 2 ) , :...
        ) );
    
else
    
    y_min_prob = min( y_prob );
    
end
% Minimum location
ind_min = find( y_prob == y_min_prob , 1 );

x_min_prob = obj.prob.x( ind_min ,~obj.env_lab );

obj.hist.y_min_prob = [ obj.hist.y_min_prob ; y_min_prob ];
obj.hist.x_min_prob = [ obj.hist.x_min_prob ; x_min_prob ];

if obj.m_g >= 1
    g_min_prob = g_prob( ind_min, obj.g_ind );
    obj.hist.g_min_prob = [ obj.hist.g_min_prob ; g_min_prob ];
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


