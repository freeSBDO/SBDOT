function X_filter = K_filtering( obj, x_new )
% K_FILTERING
% Method for gaussian process classes
% Select before evaluation relevent points by looking at reduction of MSE


if isa(obj.meta_y,'Kriging')
    
    for i = 1 : obj.m_y
        
        [ ~, mse_pred_temp(:,i) ] = obj.meta_y(i).Predict(x_new);
        
    end
    
    mse_pred_init = sum( mse_pred_temp, 2 );
    
    X_filter = Scale_data( x_new(1,:), obj.prob.lb, obj.prob.ub);
    Y_filter = 1;
    
    for i= 1 : obj.m_y
        krig_var_updated(i,:) = obj.meta_y(i,:).k_oodace.fit( ...
            [ obj.meta_y(i).x_train ; X_filter ], [ obj.prob.y(:,obj.y_ind(i)) ; Y_filter]);
    end
    
    for j = 2 : size(x_new,1)
        
        for i = 1 : obj.m_y
            [ ~, mse_current(:,i) ] = krig_var_updated(i).predict( x_new(j,:) );
        end
        mse_current = sum( mse_current, 2 );
        
        if ( mse_current / mse_pred_init(j) ) > 0.1
            
            X_filter = [ X_filter ; Scale_data(x_new(j,:), obj.prob.lb, obj.prob.ub) ];
            Y_filter = [ Y_filter ; 1 ];
            for i=1:obj.m_y
                krig_var_updated(i,:)=obj.meta_y(i,:).k_oodace.fit( ...
                    [ obj.meta_y(i).x_train ; X_filter ], ...
                    [ obj.prob.y(:,obj.y_ind(i)) ; Y_filter ]);
            end
        end
        
    end
else
    error('SBDO:Adaptive_sampling:k_filtering','Filtering method is only for Kriging')
end
end