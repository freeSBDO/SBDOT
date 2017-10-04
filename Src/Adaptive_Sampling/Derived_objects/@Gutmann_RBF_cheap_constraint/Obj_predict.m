function [ y_pred ] = Obj_predict( obj, x )
% OBJ_PREDICT
%   Objective function to find the actual minimum on prediction

% cheap constraint 
cheap_cons = feval( obj.func_cheap, x ); 

y_pred = obj.meta_y.Predict(x);

% Handle constraint in optimization (death penalty with CMAES)
if obj.m_g >= 1
    for i = 1 : obj.m_g
        g_pred(:,i) = obj.meta_g(i).Predict(x);
    end
    y_pred( any(g_pred > 0, 2), : ) = nan( sum(any( g_pred > 0, 2 )), 1 );
end

y_pred( any( cheap_cons > 0, 2 ) , : ) = nan( size( sum( any(cheap_cons<0,2) , 1 ) ) );

end