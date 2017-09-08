function [ y_rob, mse_y_rob, g_rob, mse_g_rob ] = Eval_rob_meas( obj, x_test )
% EVAL_ROB_MEAS

nb_points = size(x_test,1);

for i = 1 : obj.m_y
    if isequal(obj.meta_type,@Q_kriging)
        n_test = size(x_test,1);
        [ y_pred(:,i), mse_y_pred(:,i) ] = obj.meta_y(i).Predict( x_test,repmat(obj.QV_val,n_test,1) );
    else
        [ y_pred(:,i), mse_y_pred(:,i) ] = obj.meta_y(i).Predict( x_test );
    end
end

mse_y_rob = obj.Worstcase_meas( mse_y_pred', nb_points );
y_rob = feval( obj.meas_type_y, obj, y_pred', nb_points );

if obj.m_g > 0
    
    for i = 1 : obj.m_g
        
        if isequal(obj.meta_type,@Q_kriging)
            [ g_pred(:,i), mse_g_pred(:,i) ] = obj.meta_g(i,:).Predict( x_test,repmat(obj.QV_val,n_test,1) );
        else
            [ g_pred(:,i), mse_g_pred(:,i) ] = obj.meta_g(i,:).Predict( x_test );
        end                
        
        if isequal( obj.meas_type_g, @Worstcase_meas )
            
            [ g_rob(:,i), id_meas ] = feval( obj.meas_type_g, obj, g_pred(:,i), nb_points );
            
            mse_reshape = reshape( mse_g_pred(:,i), obj.CRN_samples, nb_points );
            mse_g_rob(:,i) = diag( mse_reshape(id_meas, 1:nb_points) );
            
        else
            
            g_rob(:,i) = feval( obj.meas_type_g, obj, g_pred(:,i), nb_points );
            mse_g_rob(:,i) = obj.Worstcase_meas( mse_g_pred(:,i), nb_points );
            
        end
        
    end
    
else
    
    g_rob=[];
    mse_g_rob=[];
    
end

end

