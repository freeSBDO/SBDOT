function [ y_pred ] = Prediction( obj, x )
% PREDICTION
% use for min_current search

y_pred = obj.meta_y.Predict(x);

if obj.m_g >= 1
    for i = 1 : obj.m_g
        g_pred(:,i) = obj.meta_g(i).Predict(x);
    end
    y_pred( any(g_pred > 0, 2), : ) = nan( sum(any( g_pred > 0, 2 )), 1 );
end

end

