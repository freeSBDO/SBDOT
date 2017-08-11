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

