function [ mean_theta, lb_theta, ub_theta ] = Theta_bound_normal( x )
% THETA_BOUND_NORMAL 
% Bound and start value for correlation parameter estimation
% on normalized data.
%
%   x (n by m matrix) is the input matrix of the dataset
%
% Syntax :
% [mean_theta,lb_theta,ub_theta]=Theta_bound_normal(x);


%% Normalize x
[n, m] = size( x );
inputAvg = mean( x );
inputStd = std( x );
x = (x - inputAvg(ones(n,1),:)) ./ inputStd(ones(n,1),:);

% Manhattan Distance between input points calculation
x_2 = permute(x',[3 1 2]);
dist = abs(bsxfun(@minus,x,x_2)); 
for i = 1 : m 
    
    dist_dim (:,:) = dist(:,i,:);
    dist_dim_triu = triu(dist_dim);
    dist_final_int = reshape(dist_dim_triu,1,size(x,1)^2);
    dist_final_int(dist_final_int==0)=[];
    dist_final( :, i ) = dist_final_int;
    
end

%% Heuristic rule for kriging correlation parameter estimation or gamma for RBF

lb_theta = min( dist_final , [] , 1 );
ub_theta = max( dist_final , [] , 1 );
mean_theta = mean( dist_final , 1 );

end

