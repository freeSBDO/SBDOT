function opt_x = reg_polytopes ( x, r, k, d )
    % REG_POLYTOPES computes the corners of a polytope with k corners centred on x
    % inscribed in the hypersphere of radius r in dimension d. It is used
    % to generate k points in dimension d surrounding x at distance r, such
    % as, the minimal inter-point distance between the k points is
    % maximized.
    % 
    %   Inputs:
    %       x center of the generated polytope
    %       r radius of the hypersphere
    %       k number of desired corners
    %       d the dimension of the problem
    %
    %   Output:
    %       opt_x is a k x d matrix contraining the corners
    %
    % Syntax:
    %   opt_x = reg_polytopes ( x, r, k, d );
    
    Theta = stk_sampling_sobol( 10^4, d-1, 2*pi*[zeros(1,d-1);ones(1,d-1)], true );
    bounds = 2*pi*[zeros(k*(d-1),1),ones(k*(d-1),1)];
    opts.LBounds = bounds(:,1); opts.UBounds = bounds(:,2);
    Clust = Kmeans_SBDO( Theta.data, k );
    Clust = reshape( Clust, k*(d-1), 1 );
    func = @(x) inter_min( x, k, r, d );
    options = optimoptions('fmincon','Display','none','Algorithm','active-set');
    opt_x = fmincon(func, Clust', [], [], [], [], opts.LBounds', opts.UBounds', [], options);
    opt_x = reshape(opt_x',k,d-1);
    opt_x = hypersph2cart( [r*ones(1,k); opt_x'] )';
    opt_x = repmat(x, size(opt_x, 1), 1) + opt_x;
    
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


