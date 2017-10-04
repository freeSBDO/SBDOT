function [ crit ] = Gutmann_crit( obj, x ,min_target )
% GUTMANN_CRIT
%   Evaluate the Gutmann criterion

[ y_pred, power ] = obj.meta_y.Predict(x);

% Gutmann criterion
crit = - log( (1./(y_pred - min_target).^2) .* power );

% Handle constraint in optimization (death penalty with CMAES)
if obj.m_g >= 1
    for i = 1 : obj.m_g
        g_pred(:,i) = obj.meta_g(i).Predict(x);
    end
    crit( any(g_pred > 0, 2), : ) = nan( sum(any( g_pred > 0, 2 )), 1 );
end

end

