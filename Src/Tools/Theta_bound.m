function [ mean_theta, lb_theta, ub_theta ] = Theta_bound( x )
% THETA_BOUN
% Bound and start value for correlation parameter estimation
%
%   x (n by m matrix) is the input matrix of the dataset
%
% Syntax :
% [mean_theta,lb_theta,ub_theta]=Theta_bound_normal(x);

 m = size( x, 2 );
 
 % Manhattan Distance between input points calculation
 x_2 = permute(x',[3 1 2]);
 dist = abs(bsxfun(@minus,x,x_2));
 for i = 1 : m
     
     dist_dim (:,:) = dist(:,i,:);
     dist_dim_triu = triu(dist_dim);
     dist_final_int = reshape(dist_dim_triu,1,size(x,1)^2);
     dist_final_int(dist_final_int==0)=[];
     dist_final{ i } = dist_final_int;
     
 end

%% Heuristic rule for kriging correlation parameter estimation or gamma for RBF

lb_theta = cellfun(@min,dist_final);
ub_theta = cellfun(@max,dist_final);
mean_theta = cellfun(@mean,dist_final);

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


