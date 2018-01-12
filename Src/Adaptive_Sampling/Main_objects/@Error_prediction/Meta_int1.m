function func_val = Meta_int1(obj, x )
%META_INT1 Summary of this function goes here
% Use for 1D integration with @integral

[n1,n2]=size(x);

x = reshape(x,n1*n2,1);

if obj.m_y >= 1
    [~,func_val] = obj.meta_y.Predict(x);
end
if obj.m_g >= 1
    [~,func_val] = obj.meta_g.Predict(x);
end
          
func_val = reshape(func_val,n1,n2);

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


