function dist_theta = Norm_theta(~, diff_mat, theta )
% NORM_THETA 
%   Scaled distances between points with theta
%   - diff_mat is the matrix of squared manhattan distance
%   - theta is the hyperparameter vector (in log scale)

theta_squared = 10.^(theta);

dist_theta(:,:) = sqrt( ...
    sum( bsxfun( @times, diff_mat, theta_squared ), 2 ) ....
                    );

end

