function LOO = Loo_error( obj, theta )
% LOO_ERROR Estimates LOO error for a given theta (Rippa formula)
%
% theta is the hyperparameter vector (in 10^ scale)

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

