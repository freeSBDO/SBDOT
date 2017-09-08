function [ obj_val ] = Optim_env( obj, x_env, x_new_rob )
% OPTIM_ENV
%

nbr_points = size(x_env,1);

x_eval = [ repmat( x_new_rob, nbr_points, 1) x_env ];

if isequal(obj.meta_type,@Q_kriging)
    [ ~, mse_y_pred ] = obj.meta_y.Predict( x_eval,repmat(obj.QV_val,nbr_points,1) );
else
    [ ~, mse_y_pred ] = obj.meta_y.Predict( x_eval );
end

if obj.m_g>0
    for i=1:obj.m_g
        if isequal(obj.meta_type,@Q_kriging)
            [ ~, mse_g_pred(:,i) ] = obj.meta_g(i,:).Predict( x_eval,repmat(obj.QV_val,nbr_points,1) );
        else
            [ ~, mse_g_pred(:,i) ] = obj.meta_g(i,:).Predict( x_eval );
        end 
    end
    obj_val = -max( [mse_y_pred mse_g_pred], [], 2 );
else
    obj_val = -mse_y_pred;
end

end

