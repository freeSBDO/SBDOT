function LOO = Loo_error( obj, theta )
% LOO_ERROR 
%   Estimates LOO error for a given theta (Rippa formula)
%   - theta is the hyperparameter vector (in 10^ scale)

[corr_mat, f_mat, zero_mat] = feval( obj.corr, obj, obj.diff_squared, theta);

corr_mat = corr_mat + eye( size(corr_mat,1) )*10000*eps;

param = [ corr_mat f_mat; f_mat' zero_mat ] \ ...
    [ obj.f_train ; zeros( size( f_mat , 2 ) , 1 ) ];

switch obj.estimator
    
    case 'LOO'

        LOO_vector = ( param( 1:obj.prob.n_x ) ./ diag(inv( corr_mat )) );

        LOO = sum( LOO_vector.^2 );

    case 'CV'
        
        cv1 = param( 1:obj.prob.n_x ) .^ 2;
        
        cv2 = mean( diag(inv( corr_mat )) ) .^ 2;
        
        LOO = sum( cv1 ) / cv2;
        
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


