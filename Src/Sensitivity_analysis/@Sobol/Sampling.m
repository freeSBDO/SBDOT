function [ A, B ] = Sampling( obj )
% SAMPLING
% Generate Sobol sampling for indice computation
% See Saltelli et. al. 2009 (section 5.1)

if isa(obj.func_obj,'Problem')
    lb = obj.func_obj.lb;
    ub = obj.func_obj.ub;
else
    lb = obj.func_obj.prob.lb;
    ub = obj.func_obj.prob.ub;
end

x_temp = stk_sampling_sobol( obj.n_MC, 2*obj.m, [lb lb; ub ub], true );
x_sampling = x_temp.data;

A = x_sampling( :, 1:obj.m );
B = x_sampling( :, obj.m+1:end );

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


