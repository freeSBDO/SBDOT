function [ x_eval_scaled ] = Predict( obj, x_eval )
% PREDICT
%   Evaluates the metamodel at x_eval
%   *x_eval is a n_eval by m_x matrix
%   *x_eval_scaled is x_eval scaled
%
% Syntax :
% [ x_eval_scaled ]=obj.predict(x_eval);

assert( size(x_eval,2) == obj.prob.m_x, ...
    'SBDOT:Metamodel:dimension_input',...
    ['Dimension of x should be ' num2str(obj.prob.m_x) ' instead of ' num2str(size(x_eval,2)) '.'] )

% Data scaling
x_eval_scaled = Scale_data( x_eval, ...
    obj.prob.lb, obj.prob.ub);

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


