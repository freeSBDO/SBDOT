function [ x_CRN ] = Update_CRN( obj, x_test )
% UPDATE_CRN
%   (see also Compute_CRN help)
%   * photonic variable :
%   phot_int = CRN_mat * cd_min (which is the minimum values of photonic variables)
%   x_CRN = phot_int + x_test (+-10% of minimum photonic parameters values)
%   * environmental variable :
%   x_CRN = CRN_mat 
%   ** if a variable is photonic and environmental, the photonic sequence
%   is used.
%   * classic variable
%   x_CRN = CRN_mat + x_test

x_CRN = zeros( size(x_test,1) * obj.CRN_samples, obj.prob.m_x );

% Minimum length of photonic variables
cd_min = repmat( min(x_test(:,obj.phot_lab),[],2),1,nnz(obj.phot_lab)); 

phot_int = bsxfun( @times,...
    permute(obj.CRN_matrix(:,obj.phot_lab), [1 3 2]), ...
    permute(cd_min, [3 1 2]) );

x_CRN(:,obj.phot_lab) = reshape( bsxfun( @plus, ...
    phot_int, ...
    permute( x_test(:,obj.phot_lab), [3 1 2] ) ), ...
    size(x_test,1) * obj.CRN_samples, nnz(obj.phot_lab) );

x_test(:,obj.phot_lab) = [];

x_CRN(:, ~obj.phot_lab & ~obj.env_lab ) = reshape( ...
    bsxfun( @plus, ...
    permute( obj.CRN_matrix(:, ~obj.phot_lab & ~obj.env_lab ),[1 3 2]), ...
    permute(x_test,[3 1 2]) ), ...
    size(x_test,1)*obj.CRN_samples, size(x_test,2) );

x_CRN( :, obj.env_lab ) = repmat( obj.CRN_matrix(:,obj.env_lab),...
    size(x_test,1), 1 );

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


