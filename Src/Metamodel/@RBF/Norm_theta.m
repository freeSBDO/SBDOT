function dist_theta = Norm_theta(~, diff_mat, theta )
% NORM_THETA Scaled distances between points with theta
%
% theta is the hyperparameter vector (in log scale)

theta_squared = 10.^(theta);

dist_theta(:,:) = sqrt( ...
    sum( bsxfun( @times, diff_mat, theta_squared ), 2 ) ....
                    );

end

