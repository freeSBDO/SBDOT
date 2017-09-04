function [ y_rob, mse_y_rob, g_rob, mse_g_rob ] = Eval_rob_meas( obj, x_test )
% EVAL_ROB_MEAS

nb_points = size(x_test,1);

x_CRN = obj.Update_CRN(x_test);

if isequal(obj.meta_type,@Q_kriging)
    n_test = size(x_test,1);
    [ y_pred, mse_y_pred ] = obj.meta_y.Predict( x_CRN,repmat(obj.QV_val,n_test,1) );
    %[ ~, mse_y_rob ] = obj.meta_y.Predict( x_test,repmat(obj.QV_val,n_test,1) );
else
    [ y_pred, mse_y_pred ] = obj.meta_y.Predict( x_CRN );
    %[ ~, mse_y_rob ] = obj.meta_y.Predict( x_test );
end

% if isequal( obj.meas_type_y, @Worstcase_meas )
%     
%     [ y_rob,id_meas ] = feval( obj.meas_type_y, obj, y_pred, nb_points );
%     
%     mse_reshape = reshape( mse_y_pred, obj.CRN_samples, nb_points );
%     mse_y_rob = diag( mse_reshape(id_meas, 1:nb_points) );
%     
% else
%     
%     y_rob = feval( obj.meas_type_y, obj, y_pred, nb_points );
%     mse_y_rob = feval( @obj.Mean_meas, mse_y_pred, nb_points );
%     
% end

[ ~, mse_y_rob ] = obj.meta_y.Predict( obj.X_to_rob(x_test) );
y_rob = feval( obj.meas_type_y, obj, y_pred, nb_points );

if obj.m_g > 0
    
    for i = 1 : obj.m_g
        
        if isequal(obj.meta_type,@Q_kriging)
            [ g_pred(:,i), mse_g_pred(:,i) ] = obj.meta_g(i,:).Predict( x_CRN,repmat(obj.QV_val,n_test,1) );
        else
            [ g_pred(:,i), mse_g_pred(:,i) ] = obj.meta_g(i,:).Predict( x_CRN );
        end                
        
        if isequal( obj.meas_type_g, @Worstcase_meas )
            
            [ g_rob(:,i), id_meas ] = feval( obj.meas_type_g, obj, g_pred(:,i), nb_points );
            
            mse_reshape = reshape( mse_g_pred(:,i), obj.CRN_samples, nb_points );
            mse_g_rob(:,i) = diag( mse_reshape(id_meas, 1:nb_points) );
            
        else
            
            g_rob(:,i) = feval( obj.meas_type_y, obj, g_pred(:,i), nb_points );
            mse_g_rob(:,i) = feval( @obj.Mean_meas, mse_g_pred(:,i), nb_points );
            
        end
        
    end
    
else
    
    g_rob=[];
    mse_g_rob=[];
    
end

end

