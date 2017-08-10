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
 dist2(:,:) = sum(dist,2);
 
 dist_dim_triu = triu(dist2);
 dist_final = reshape(dist_dim_triu,1,size(x,1)^2);
 dist_final(dist_final==0)=[];
 

%% Heuristic rule for kriging correlation parameter estimation or gamma for RBF

lb_theta = min( dist_final) * ones (1,m);
ub_theta = max( dist_final) * ones (1,m);
mean_theta = mean( dist_final) * ones (1,m);

end

