function [ crit ] = Gutmann_crit( obj, x ,min_target )
% GUTMANN_CRIT
% 

[ y_pred, power ] = obj.meta_y.Predict(x);

crit = - log( (1./(y_pred - min_target).^2) .* power );

if obj.m_g >= 1
    for i = 1 : obj.m_g
        g_pred(:,i) = obj.meta_g(i).Predict(x);
    end
    crit( any(g_pred > 0, 2), : ) = nan( sum(any( g_pred > 0, 2 )), 1 );
end

end

